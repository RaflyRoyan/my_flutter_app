import '../../core/api_client.dart';
import '../../core/api_result.dart';
import 'auth.dart';

/// Endpoint `api/auth` (CekReklameApi `AuthController`).
class AuthService {
  AuthService(this._api);

  final ApiClient _api;

  /// `POST /api/auth/login`
  Future<ApiResult<LoginResponse>> login(String nip, String password) =>
      _api.post('/api/auth/login', {
        'nip': nip,
        'password': password,
      }, (data) => LoginResponse.fromJson(data as Map<String, dynamic>));
}
