import '../../core/base_controller.dart';

import '../../core/session.dart';
import '../../data/auth/auth_service.dart';

/// Padanan `LoginController` + `LoginVM` di web.
class LoginController extends BaseController {
  LoginController(this._authService, this._session);

  final AuthService _authService;
  final Session _session;

  bool isLoading = false;
  String? message;

  /// Return `true` bila login berhasil dan sesi tersimpan.
  Future<bool> doLogin(String nip, String password) async {
    isLoading = true;
    message = null;
    notifyListeners();

    final result = await _authService.login(nip.trim(), password);

    if (!result.isSuccess) {
      message = result.message;
    } else if (result.data!.isResetPassword) {
      // Alur ganti password (`POST /api/auth/resetPassword`) belum dibuat
      // di contoh ini, jadi sesi tidak disimpan.
      message =
          'Akun Anda dalam status reset password. '
          'Silakan ganti password terlebih dahulu.';
    } else {
      await _session.simpan(result.data!.token);
    }

    isLoading = false;
    notifyListeners();
    return _session.isUserLoggedIn;
  }
}
