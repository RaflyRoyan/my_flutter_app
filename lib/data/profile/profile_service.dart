import '../../core/api_client.dart';
import '../../core/api_result.dart';
import 'profile.dart';

/// Endpoint `api/profile` (CekReklameApi `ProfileController`).
class ProfileService {
  ProfileService(this._api);

  final ApiClient _api;

  /// `GET /api/profile` — profil pegawai pemilik token.
  Future<ApiResult<Profile>> getProfile() => _api.get(
    '/api/profile',
    (data) => Profile.fromJson(data as Map<String, dynamic>),
  );
}
