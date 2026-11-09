import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

/// Displays consistent success, error, and informational feedback.
abstract final class AppFeedback {
  /// Displays a successful operation message.
  static void showSuccess(BuildContext context, String message) =>
      _show(context, message, color: Theme.of(context).colorScheme.primary);

  /// Displays an error and an optional retry action.
  static void showError(
    BuildContext context,
    String message, {
    VoidCallback? onRetry,
  }) => _show(
    context,
    message,
    color: Theme.of(context).colorScheme.error,
    action: onRetry == null
        ? null
        : SnackBarAction(
            label: AppStrings.retry,
            textColor: Colors.white,
            onPressed: onRetry,
          ),
  );

  /// Displays a neutral informational message.
  static void showInfo(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) => _show(
    context,
    message,
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    action: actionLabel == null || onAction == null
        ? null
        : SnackBarAction(
            label: actionLabel,
            textColor: Colors.white,
            onPressed: onAction,
          ),
  );

  static void _show(
    BuildContext context,
    String message, {
    required Color color,
    SnackBarAction? action,
  }) {
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          action: action,
        ),
      );
  }
}
