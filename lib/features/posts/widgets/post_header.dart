import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../models/user_account.dart';
import '../../../models/user_post.dart';
import 'profile_avatar.dart';

/// Author and timestamp header for a post.
class PostHeader extends StatelessWidget {
  /// Creates a post header.
  const PostHeader({required this.account, required this.post, super.key});

  /// Post author account.
  final UserAccount account;

  /// Post metadata.
  final UserPost post;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSizes.pagePadding),
    child: Row(
      children: [
        ProfileAvatar(path: account.avatarPath),
        const SizedBox(width: AppSizes.cardGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account.name,
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              Text(post.time, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        const Icon(Icons.more_horiz_rounded),
      ],
    ),
  );
}
