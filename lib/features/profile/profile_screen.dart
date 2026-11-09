import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../models/user_account.dart';
import 'widgets/friends_grid.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_post_card.dart';
import 'widgets/profile_section_title.dart';
import 'widgets/stats_row.dart';

/// Profile feed with one scrollable sliver viewport.
class ProfileScreen extends StatelessWidget {
  /// Creates the profile screen for [account].
  const ProfileScreen({required this.account, super.key});

  /// Profile account rendered by this screen.
  final UserAccount account;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        AppStrings.appName,
        style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
      ),
    ),
    body: CustomScrollView(
      key: const PageStorageKey<String>('profile-scroll'),
      slivers: [
        SliverToBoxAdapter(child: ProfileHeader(account: account)),
        SliverToBoxAdapter(
          child: StatsRow(
            followers: account.followers,
            following: account.following,
            posts: account.posts.length,
          ),
        ),
        SliverToBoxAdapter(
          child: ProfileSectionTitle(
            title: AppStrings.friends,
            count: account.friends.length,
          ),
        ),
        if (account.friends.isEmpty)
          const SliverToBoxAdapter(
            child: _EmptyState(message: AppStrings.noFriends),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.pagePadding,
            ),
            sliver: FriendsGrid(friends: account.friends),
          ),
        SliverToBoxAdapter(
          child: ProfileSectionTitle(
            title: AppStrings.posts,
            count: account.posts.length,
          ),
        ),
        if (account.posts.isEmpty)
          const SliverToBoxAdapter(
            child: _EmptyState(message: AppStrings.noPosts),
          )
        else
          SliverList.builder(
            itemCount: account.posts.length,
            itemBuilder: (context, index) {
              final post = account.posts[index];
              return ProfilePostCard(
                account: account,
                post: post,
                onTap: () =>
                    Navigator.of(context)
                        .pushNamed(AppRoutes.post, arguments: post),
              );
            },
          ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.pagePadding)),
      ],
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSizes.pagePadding * 2),
    child: Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
