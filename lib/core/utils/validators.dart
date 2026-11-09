import '../constants/app_strings.dart';

/// Provides validators for required sign-in fields.
abstract final class AppValidators {
  /// Validates that a username contains non-whitespace text.
  static String? username(String? value) =>
      value == null || value.trim().isEmpty
      ? AppStrings.requiredUsername
      : null;

  /// Validates that a password contains at least six characters.
  static String? password(String? value) {
    if (value == null || value.isEmpty) return AppStrings.requiredPassword;
    if (value.length < 6) return AppStrings.shortPassword;
    return null;
  }
}
