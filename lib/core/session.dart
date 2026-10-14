import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Padanan `HttpContext.Session` + `HttpContextExtensions` di web.
/// Menyimpan token JWT dari `POST /api/auth/login`.
class Session extends ChangeNotifier {
  Session({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _keyToken = 'SESSION_TOKEN';

  final FlutterSecureStorage _storage;
  String? _token;

  /// Pesan untuk halaman login saat sesi berakhir paksa (mis. token 401).
  String? pesanLogout;

  String? get token => _token;
  bool get isUserLoggedIn => _token != null;

  /// Dipanggil sekali saat aplikasi dibuka.
  Future<void> muat() async {
    _token = await _storage.read(key: _keyToken);
    notifyListeners();
  }

  Future<void> simpan(String token) async {
    _token = token;
    pesanLogout = null;
    await _storage.write(key: _keyToken, value: token);
    notifyListeners();
  }

  Future<void> hapus({String? pesan}) async {
    _token = null;
    pesanLogout = pesan;
    await _storage.delete(key: _keyToken);
    notifyListeners();
  }
}
