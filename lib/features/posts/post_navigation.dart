import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';

/// Handles post-screen back navigation and unsent-comment confirmation.
abstract final class PostNavigation {
  /// Leaves the post when possible, confirming if a draft would be discarded.
  static Future<void> requestPop(
    BuildContext context, {
    required bool hasDraft,
  }) async {
    final navigator = Navigator.of(context);
    if (!navigator.canPop()) return;
    if (hasDraft) {
      final leave = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text(AppStrings.unsentWarning),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(AppStrings.stay),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(AppStrings.leavePost),
            ),
          ],
        ),
      );
      if (!context.mounted || leave != true) return;
    }
    if (context.mounted && navigator.canPop()) navigator.pop();
  }
}
