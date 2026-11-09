import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/user_account.dart';
import '../../posts/widgets/profile_avatar.dart';

/// Displays profile avatar, identity, and bio.
class ProfileHeader extends StatelessWidget {
  /// Creates the profile header for [account].
  const ProfileHeader({required this.account, super.key});

  /// Account information shown in the header.
  final UserAccount account;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.fromLTRB(
      AppSizes.pagePadding,
      AppSizes.pagePadding / 2,
      AppSizes.pagePadding,
      AppSizes.cardGap,
    ),
    child: Padding(
      padding: const EdgeInsets.all(AppSizes.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProfileAvatar(
                path: account.avatarPath,
                radius: AppSizes.profileAvatarRadius,
              ),
              const SizedBox(width: AppSizes.cardGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: AppSizes.tinyGap),
                    Text(
                      AppStrings.creator,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      account.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.cardGap),
          Text(AppStrings.profileBio),
        ],
      ),
    ),
  );
}
