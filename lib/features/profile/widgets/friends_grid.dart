import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../models/friend.dart';
import 'friend_tile.dart';

/// Sliver grid for friends in the profile.
class FriendsGrid extends StatelessWidget {
  /// Creates a three-column friends grid.
  const FriendsGrid({required this.friends, super.key});

  /// Friend list rendered by this grid.
  final List<Friend> friends;

  @override
  Widget build(BuildContext context) => SliverGrid(
    delegate: SliverChildBuilderDelegate(
      (context, index) => FriendTile(friend: friends[index]),
      childCount: friends.length,
    ),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: AppSizes.friendColumns,
      crossAxisSpacing: AppSizes.cardGap,
      mainAxisSpacing: AppSizes.cardGap,
      childAspectRatio: AppSizes.friendAspectRatio,
    ),
  );
}
