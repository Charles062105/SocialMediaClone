import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

/// Standard post detail scaffold with guarded back navigation.
class PostScreenScaffold extends StatelessWidget {
  /// Creates the post detail page shell.
  const PostScreenScaffold({
    required this.hasDraft,
    required this.onBack,
    required this.content,
    required this.commentInput,
    super.key,
  });

  /// Whether the comment field contains an unsent draft.
  final bool hasDraft;

  /// Handles both toolbar and system back actions.
  final VoidCallback onBack;

  /// Post feed and comments.
  final Widget content;

  /// Pinned comment composer.
  final Widget commentInput;

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !hasDraft,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) onBack();
    },
    child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: AppStrings.backToProfile,
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(AppStrings.posts),
      ),
      body: content,
      bottomNavigationBar: commentInput,
    ),
  );
}
