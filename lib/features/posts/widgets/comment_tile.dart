import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/user_comment.dart';
import 'profile_avatar.dart';

/// Displays one comment with Like, Reply, and Delete actions.
class CommentTile extends StatelessWidget {
  /// Creates a comment tile.
  const CommentTile({
    required this.comment,
    required this.onLike,
    required this.onReply,
    required this.onDelete,
    super.key,
  });

  /// Comment being displayed.
  final UserComment comment;

  /// Toggles the comment like.
  final VoidCallback onLike;

  /// Starts a reply.
  final VoidCallback onReply;

  /// Requests deletion confirmation.
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: AppSizes.scrollDuration,
    builder: (context, progress, child) => Opacity(
      opacity: progress,
      child: Transform.translate(
        offset: Offset(0, (1 - progress) * AppSizes.cardGap),
        child: child,
      ),
    ),
    child: Card(
      margin: const EdgeInsets.fromLTRB(
        AppSizes.pagePadding,
        AppSizes.tinyGap,
        AppSizes.pagePadding,
        AppSizes.cardGap,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.pagePadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileAvatar(path: comment.avatarPath),
            const SizedBox(width: AppSizes.cardGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          comment.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      Text(
                        comment.time,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      IconButton(
                        tooltip: AppStrings.deleteCommentAction,
                        visualDensity: VisualDensity.compact,
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline_rounded),
                      ),
                    ],
                  ),
                  Text(comment.text),
                  const SizedBox(height: AppSizes.smallGap),
                  Wrap(
                    spacing: AppSizes.cardGap,
                    children: [
                      AnimatedScale(
                        scale: comment.isLiked ? 1.08 : 1,
                        duration: AppSizes.scrollDuration,
                        child: TextButton(
                          onPressed: onLike,
                          child: Text(
                            '${AppStrings.like} ${comment.likes}',
                            style: TextStyle(
                              color: comment.isLiked
                                  ? Theme.of(context).colorScheme.tertiary
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: onReply,
                        child: const Text(AppStrings.reply),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
