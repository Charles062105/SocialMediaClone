import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/feedback.dart';
import '../../../models/user_comment.dart';
import 'post_screen_controller.dart';

/// Performs comment interactions that need persistence and user feedback.
abstract final class PostCommentActions {
  /// Loads comments and reports recoverable storage warnings.
  static Future<void> load(
    BuildContext context,
    PostScreenController controller,
  ) async {
    await controller.load();
    if (!context.mounted) return;
    final warning = controller.comments.warning;
    if (warning != null) {
      AppFeedback.showError(
        context,
        warning,
        onRetry: () => unawaited(load(context, controller)),
      );
    }
  }

  /// Confirms and deletes a comment, offering Undo after a successful save.
  static Future<void> delete(
    BuildContext context,
    PostScreenController controller,
    UserComment comment,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteComment),
        content: const Text(AppStrings.deleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
    if (!context.mounted || confirmed != true) return;
    final saved = await controller.deleteComment(comment);
    if (!context.mounted) return;
    if (!saved) {
      AppFeedback.showError(
        context,
        controller.comments.warning ?? AppStrings.commentSaveFailed,
        onRetry: () => unawaited(delete(context, controller, comment)),
      );
      return;
    }
    AppFeedback.showInfo(
      context,
      AppStrings.deleted,
      actionLabel: AppStrings.undo,
      onAction: () => unawaited(restore(context, controller)),
    );
  }

  /// Restores the most recently deleted comment.
  static Future<void> restore(
    BuildContext context,
    PostScreenController controller,
  ) async {
    if (controller.lastDeleted == null) return;
    final restored = await controller.restoreLastDeleted();
    if (!context.mounted) return;
    if (restored) {
      AppFeedback.showSuccess(context, AppStrings.restored);
    } else {
      AppFeedback.showError(
        context,
        controller.comments.warning ?? AppStrings.commentSaveFailed,
        onRetry: () => unawaited(restore(context, controller)),
      );
    }
  }

  /// Toggles a comment's Like state and reports persistence failures.
  static Future<void> toggleLike(
    BuildContext context,
    PostScreenController controller,
    UserComment comment,
  ) async {
    await safeHaptic(HapticFeedback.selectionClick());
    if (!context.mounted) return;
    final saved = await controller.toggleCommentLike(comment.id);
    if (!context.mounted || saved) return;
    AppFeedback.showError(
      context,
      controller.comments.warning ?? AppStrings.commentSaveFailed,
      onRetry: () => unawaited(toggleLike(context, controller, comment)),
    );
  }

  /// Runs haptic feedback when supported by the current platform.
  static Future<void> safeHaptic(Future<void> feedback) async {
    try {
      await feedback;
    } catch (error, stackTrace) {
      debugPrint('TIKTOKTOK: Haptic feedback unavailable: $error\n$stackTrace');
    }
  }
}
