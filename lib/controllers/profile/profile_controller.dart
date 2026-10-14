import '../../core/base_controller.dart';

import '../../core/session.dart';
import '../../data/profile/profile.dart';
import '../../data/profile/profile_service.dart';

/// Padanan `ProfileController` + `ProfileVM.Index` di web.
class ProfileController extends BaseController {
  ProfileController(this._profileService, this._session);

  final ProfileService _profileService;
  final Session _session;

  bool isLoading = false;
  String? message;
  Profile? profile;

  Future<void> index() async {
    isLoading = true;
    message = null;
    notifyListeners();

    final result = await _profileService.getProfile();
    if (result.isSuccess) {
      profile = result.data;
    } else {
      message = result.message;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() => _session.hapus();
}
