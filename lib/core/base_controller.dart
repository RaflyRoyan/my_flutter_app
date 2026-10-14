import 'package:flutter/foundation.dart';

/// Induk semua controller, seperti `BaseController` di web.
///
/// Mencegah error saat proses async selesai setelah halaman ditutup
/// (mis. login berhasil -> LoginPage diganti HomePage sebelum
/// `doLogin` selesai memanggil `notifyListeners`).
abstract class BaseController extends ChangeNotifier {
  bool _disposed = false;

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
