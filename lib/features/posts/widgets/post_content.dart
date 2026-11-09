import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/user_account.dart';
import '../../../models/user_comment.dart';
import '../../../models/user_post.dart';
import '../comment_sort_order.dart';
import 'action_bar.dart';
import 'comment_list.dart';
import 'post_header.dart';
import 'post_image.dart';

/// Sliver content for a post, actions, and its comments.
class PostContent extends StatelessWidget {
  /// Creates post detail content.
  const PostContent({
    required this.account,
    required this.post,
    required this.comments,
    required this.newestKey,
    required this.isLiked,
    required this.likeCount,
    required this.sortOrder,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onSortChanged,
    required this.onCommentLike,
    required this.onReply,
    required this.onDelete,
    super.key,
  });

  /// Post author account.
  final UserAccount account;

  /// Post content.
  final UserPost post;

  /// Visible comments.
  final List<UserComment> comments;

  /// Key used to reveal the newest comment after posting.
  final GlobalKey newestKey;

  /// Current post like state.
  final bool isLiked;

  /// Current post like total.
  final int likeCount;

  /// Current comment sort order.
  final CommentSortOrder sortOrder;

  /// Toggles the post like.
  final VoidCallback onLike;

  /// Focuses the comment input.
  final VoidCallback onComment;

  /// Opens share options.
  final VoidCallback onShare;

  /// Changes comment order.
  final ValueChanged<CommentSortOrder> onSortChanged;

  /// Toggles a comment's like.
  final ValueChanged<UserComment> onCommentLike;

  /// Starts a reply.
  final ValueChanged<UserComment> onReply;

  /// Requests deletion.
  final ValueChanged<UserComment> onDelete;

  @override
  Widget build(BuildContext context) => CustomScrollView(
    key: const PageStorageKey<String>('post-detail-scroll'),
    slivers: [
      SliverToBoxAdapter(
        child: Card(
          margin: const EdgeInsets.all(AppSizes.pagePadding),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostHeader(account: account, post: post),
              PostImage(post: post, aspectRatio: AppSizes.postImageRatio),
              Padding(
                padding: const EdgeInsets.all(AppSizes.pagePadding),
                child: Text(post.caption),
              ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: PostActionBar(
          isLiked: isLiked,
          likeCount: likeCount,
          onLike: onLike,
          onComment: onComment,
          onShare: onShare,
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.pagePadding),
          child: Row(
            children: [
              Text(
                formatCommentCount(comments.length),
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              PopupMenuButton<CommentSortOrder>(
                tooltip: AppStrings.sortComments,
                initialValue: sortOrder,
                onSelected: onSortChanged,
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: CommentSortOrder.newest,
                    child: Text(AppStrings.newest),
                  ),
                  PopupMenuItem(
                    value: CommentSortOrder.oldest,
                    child: Text(AppStrings.oldest),
                  ),
                ],
                child: Row(
                  children: [
                    Text(
                      sortOrder == CommentSortOrder.newest
                          ? AppStrings.newest
                          : AppStrings.oldest,
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      CommentList(
        comments: comments,
        newestKey: newestKey,
        onLike: onCommentLike,
        onReply: onReply,
        onDelete: onDelete,
      ),
    ],
  );
}
