import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import 'asset_image_view.dart';

/// Circular user avatar with a consistent image fallback.
class ProfileAvatar extends StatelessWidget {
  /// Creates an avatar from a bundled image.
  const ProfileAvatar({
    required this.path,
    this.radius = AppSizes.avatarRadius,
    super.key,
  });

  /// Bundled image path.
  final String path;

  /// Avatar radius.
  final double radius;

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: radius,
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: ClipOval(
      child: SizedBox.square(
        dimension: radius * 2,
        child: AssetImageView(path: path, icon: Icons.person_rounded),
      ),
    ),
  );
}
