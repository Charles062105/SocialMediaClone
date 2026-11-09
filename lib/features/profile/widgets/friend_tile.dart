import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../models/friend.dart';
import '../../posts/widgets/asset_image_view.dart';

/// Uniform friend portrait tile with a centered name.
class FriendTile extends StatelessWidget {
  /// Creates a tile for [friend].
  const FriendTile({required this.friend, super.key});

  /// Friend rendered by the tile.
  final Friend friend;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.imageRadius),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.tertiary,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.friendBorderWidth),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppSizes.imageRadius - AppSizes.friendBorderWidth,
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: AssetImageView(
                    path: friend.imagePath,
                    icon: Icons.person_rounded,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: AppSizes.smallGap),
      SizedBox(
        height: AppSizes.friendNameHeight,
        child: Text(
          friend.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    ],
  );
}
