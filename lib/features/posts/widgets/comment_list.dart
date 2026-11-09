import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/user_comment.dart';
import 'comment_tile.dart';

/// Builds the comments sliver, including a clear empty state.
class CommentList extends StatelessWidget {
  /// Creates a comment list.
  const CommentList({
    required this.comments,
    required this.newestKey,
    required this.onLike,
    required this.onReply,
    required this.onDelete,
    super.key,
  });

  /// Comments in selected display order.
  final List<UserComment> comments;

  /// Scroll target for the first visible comment.
  final GlobalKey newestKey;

  /// Toggles a comment like.
  final ValueChanged<UserComment> onLike;

  /// Starts a reply to a comment.
  final ValueChanged<UserComment> onReply;

  /// Requests comment deletion.
  final ValueChanged<UserComment> onDelete;

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.pagePadding * 2),
            child: Text(AppStrings.emptyComments),
          ),
        ),
      );
    }
    return SliverList.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return KeyedSubtree(
          key: index == 0
              ? newestKey
              : ValueKey('comment-anchor-${comment.id}'),
          child: CommentTile(
            key: ValueKey(comment.id),
            comment: comment,
            onLike: () => onLike(comment),
            onReply: () => onReply(comment),
            onDelete: () => onDelete(comment),
          ),
        );
      },
    );
  }
}
