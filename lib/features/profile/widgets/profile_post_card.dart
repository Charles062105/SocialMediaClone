import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../models/user_account.dart';
import '../../../models/user_post.dart';
import '../../../core/utils/formatters.dart';
import '../../posts/widgets/post_header.dart';
import '../../posts/widgets/post_image.dart';

/// Selectable post card displayed in the profile feed.
class ProfilePostCard extends StatelessWidget {
  /// Creates a profile post card.
  const ProfilePostCard({
    required this.account,
    required this.post,
    required this.onTap,
    super.key,
  });

  /// Post author.
  final UserAccount account;

  /// Post content.
  final UserPost post;

  /// Opens the post detail view.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.fromLTRB(
      AppSizes.pagePadding,
      5,
      AppSizes.pagePadding,
      AppSizes.cardGap,
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(account: account, post: post),
          PostImage(post: post, aspectRatio: AppSizes.feedImageRatio),
          Padding(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            child: Text(post.caption),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.pagePadding,
              0,
              AppSizes.pagePadding,
              AppSizes.pagePadding,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.favorite_rounded,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 6),
                Text(formatCount(post.likes)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
