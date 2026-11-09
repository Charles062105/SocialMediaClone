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
      actions: const [_LogoutButton()],
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

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.logoutTitle),
        content: const Text(AppStrings.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );
    if (!context.mounted || confirmed != true) return;
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: AppStrings.logout,
    onPressed: () => _logout(context),
    icon: const Icon(Icons.logout_rounded),
  );
}
