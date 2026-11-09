import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import 'profile_avatar.dart';

/// Keyboard-aware composer for post comments.
class CommentInput extends StatelessWidget {
  /// Creates a comment composer.
  const CommentInput({
    required this.controller,
    required this.focusNode,
    required this.avatarPath,
    required this.enabled,
    required this.errorText,
    required this.onSubmit,
    required this.onChanged,
    super.key,
  });

  /// Text being drafted.
  final TextEditingController controller;

  /// Avatar shown beside the composer.
  final String avatarPath;

  /// Composer focus node.
  final FocusNode focusNode;

  /// Whether comment submission is available.
  final bool enabled;

  /// Validation feedback displayed below the input.
  final String? errorText;

  /// Submits text and returns whether it was persisted.
  final Future<bool> Function(String text) onSubmit;

  /// Updates the draft state used for unsent-navigation warnings.
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Material(
      elevation: AppSizes.commentBarElevation,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.cardGap),
        child: Row(
          children: [
            ProfileAvatar(path: avatarPath),
            const SizedBox(width: AppSizes.smallGap),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                enabled: enabled,
                maxLength: AppSizes.commentMaxLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                textInputAction: TextInputAction.send,
                onChanged: onChanged,
                onSubmitted: (value) => unawaited(onSubmit(value)),
                decoration: const InputDecoration(
                  hintText: AppStrings.commentHint,
                  isDense: true,
                ).copyWith(errorText: errorText),
              ),
            ),
            IconButton.filled(
              tooltip: AppStrings.sendComment,
              onPressed: enabled ? () => onSubmit(controller.text) : null,
              icon: const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ),
    ),
  );
}
