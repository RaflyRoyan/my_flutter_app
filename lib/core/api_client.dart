import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_result.dart';
import 'session.dart';

/// Pemanggil HTTP tunggal untuk semua Service.
///
/// Peran `BaseController` di web ada di sini: token dari [Session] dipasang
/// di setiap request, dan respons 401 menghapus sesi sehingga aplikasi
/// otomatis kembali ke halaman login.
class ApiClient {
  ApiClient({required this.session, String? baseUrl, http.Client? client})
    : baseUrl = baseUrl ?? defaultBaseUrl,
      _client = client ?? http.Client();

  /// Ganti saat run/build: `--dart-define=API_BASE_URL=http://10.0.2.2:5140`
  static const defaultBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5140',
  );

  static const _timeout = Duration(seconds: 30);

  final String baseUrl;
  final Session session;
  final http.Client _client;

  Future<ApiResult<T>> get<T>(String path, T Function(dynamic) parseData) =>
      _send(() => _client.get(_uri(path), headers: _headers()), parseData);

  Future<ApiResult<T>> post<T>(
    String path,
    Object body,
    T Function(dynamic) parseData,
  ) => _send(
    () => _client.post(_uri(path), headers: _headers(), body: jsonEncode(body)),
    parseData,
  );

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Map<String, String> _headers() => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (session.token != null) 'Authorization': 'Bearer ${session.token}',
  };

  Future<ApiResult<T>> _send<T>(
    Future<http.Response> Function() request,
    T Function(dynamic) parseData,
  ) async {
    final http.Response response;
    try {
      response = await request().timeout(_timeout);
    } on TimeoutException {
      return ApiResult.fail('Server tidak merespons, coba lagi.');
    } catch (_) {
      return ApiResult.fail('Tidak dapat terhubung ke server.');
    }

    ApiResult<T>? result;
    try {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      if (json is Map<String, dynamic> && json.containsKey('isSuccess')) {
        result = ApiResult.fromJson(json, parseData);
      }
    } catch (_) {
      // Body bukan JSON ApiResult — ditangani di bawah.
    }

    if (response.statusCode == 401 && session.isUserLoggedIn) {
      await session.hapus(
        pesan:
            result?.message ??
            'Session Login Telah Usai, Silahkan Login kembali',
      );
    }

    return result ??
        ApiResult.fail(
          '⚠ Server Error (${response.statusCode})',
          status: response.statusCode,
        );
  }
}
