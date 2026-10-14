/// Padanan `CekReklameApi.ApiResponse.ApiResult<T>`.
///
/// Ingat: API mengembalikan HTTP 200 untuk sebagian besar kegagalan bisnis
/// (`isSuccess = false`), jadi selalu cek [isSuccess], bukan status HTTP.
class ApiResult<T> {
  const ApiResult({
    required this.isSuccess,
    required this.title,
    required this.status,
    this.traceId,
    this.errors = const [],
    this.data,
  });

  final bool isSuccess;
  final String title;
  final int status;
  final String? traceId;
  final List<String> errors;
  final T? data;

  factory ApiResult.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic data) parseData,
  ) {
    final isSuccess = json['isSuccess'] == true;
    return ApiResult(
      isSuccess: isSuccess,
      title: json['title'] as String? ?? '',
      status: json['status'] as int? ?? 0,
      traceId: json['traceId'] as String?,
      errors:
          (json['errors'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      data: isSuccess && json['data'] != null ? parseData(json['data']) : null,
    );
  }

  factory ApiResult.fail(String title, {int status = 0}) =>
      ApiResult(isSuccess: false, title: title, status: status);

  /// Pesan yang siap ditampilkan ke pengguna.
  String get message => errors.isNotEmpty ? errors.join('\n') : title;
}
