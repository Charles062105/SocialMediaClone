import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/feedback.dart';
import '../../models/user_account.dart';
import '../../models/user_comment.dart';
import '../../models/user_post.dart';
import '../../services/comment_storage_service.dart';
import 'controllers/post_comment_actions.dart';
import 'controllers/comments_controller.dart';
import 'controllers/post_screen_controller.dart';
import 'post_navigation.dart';
import 'widgets/comment_input.dart';
import 'widgets/post_content.dart';
import 'widgets/share_post_sheet.dart';
import 'widgets/post_screen_scaffold.dart';

/// Displays a selected post and its interactive comments.
class PostScreen extends StatefulWidget {
  /// Creates post detail with its comment storage dependency.
  PostScreen({
    required this.post,
    required this.account,
    required CommentStorageService storage,
    super.key,
  }) : controller = CommentsController(
         post: post,
         account: account,
         storage: storage,
       );

  /// Post selected from the profile.
  final UserPost post;

  /// Post author account.
  final UserAccount account;

  /// State and persistence controller.
  final CommentsController controller;

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _commentController = TextEditingController();
  final _commentFocus = FocusNode();
  final _newestCommentKey = GlobalKey();
  late final PostScreenController _screenController;
  bool _hasDraft = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _screenController = PostScreenController(
      comments: widget.controller,
      post: widget.post,
    );
    unawaited(PostCommentActions.load(context, _screenController));
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocus.dispose();
    _screenController.dispose();
    super.dispose();
  }

  Future<bool> _submitComment(String rawText) async {
    if (_screenController.isSending || widget.controller.isLoading) {
      return false;
    }
    final text = rawText.trim();
    if (text.isEmpty) {
      setState(() => _validationError = AppStrings.commentRequired);
      return false;
    }
    unawaited(PostCommentActions.safeHaptic(HapticFeedback.lightImpact()));
    final saved = await _screenController.addComment(text);
    if (!mounted) return false;
    if (!saved) {
      AppFeedback.showError(
        context,
        widget.controller.warning ?? AppStrings.commentSaveFailed,
        onRetry: () => unawaited(_submitComment(text)),
      );
      return false;
    }
    _commentController.clear();
    setState(() {
      _hasDraft = false;
      _validationError = null;
    });
    AppFeedback.showSuccess(context, AppStrings.commentPosted);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = _newestCommentKey.currentContext;
      if (mounted && target != null) {
        Scrollable.ensureVisible(
          target,
          duration: AppSizes.scrollDuration,
          alignment: 0.15,
        );
      }
    });
    return true;
  }

  void _togglePostLike() {
    unawaited(PostCommentActions.safeHaptic(HapticFeedback.selectionClick()));
    if (!mounted) return;
    _screenController.togglePostLike();
  }

  void _replyTo(UserComment comment) {
    final reply = '@${comment.author} ';
    _commentController.value = TextEditingValue(
      text: reply,
      selection: TextSelection.collapsed(offset: reply.length),
    );
    setState(() => _hasDraft = true);
    _commentFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _screenController,
    builder: (context, _) => PostScreenScaffold(
      hasDraft: _hasDraft,
      onBack: () =>
          unawaited(PostNavigation.requestPop(context, hasDraft: _hasDraft)),
      content: PostContent(
        account: widget.account,
        post: widget.post,
        comments: _screenController.sortedComments,
        newestKey: _newestCommentKey,
        isLiked: _screenController.isLiked,
        likeCount: _screenController.likeCount,
        sortOrder: _screenController.sortOrder,
        onLike: _togglePostLike,
        onComment: _commentFocus.requestFocus,
        onShare: () => unawaited(
          showPostShareSheet(
            context,
            caption: widget.post.caption,
            onCopied: () {
              if (mounted) {
                AppFeedback.showSuccess(context, AppStrings.captionCopied);
              }
            },
          ),
        ),
        onSortChanged: _screenController.setSortOrder,
        onCommentLike: (comment) => unawaited(
          PostCommentActions.toggleLike(context, _screenController, comment),
        ),
        onReply: _replyTo,
        onDelete: (comment) => unawaited(
          PostCommentActions.delete(context, _screenController, comment),
        ),
      ),
      commentInput: CommentInput(
        controller: _commentController,
        focusNode: _commentFocus,
        avatarPath: widget.account.avatarPath,
        enabled: !widget.controller.isLoading && !_screenController.isSending,
        errorText: _validationError,
        onSubmit: _submitComment,
        onChanged: (value) => setState(() {
          _hasDraft = value.trim().isNotEmpty;
          if (_validationError != null && _hasDraft) {
            _validationError = null;
          }
        }),
      ),
    ),
  );
}
