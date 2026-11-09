import '../core/constants/app_strings.dart';

/// Authenticates the credentials used by the local demo app.
///
/// Replace this service with a secure backend-backed implementation before
/// using real accounts.
class DemoAuthService {
  /// Checks the demo account credentials.
  Future<bool> authenticate({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return username.trim().toLowerCase() == AppStrings.demoUsername &&
        password == AppStrings.demoPassword;
  }
}
