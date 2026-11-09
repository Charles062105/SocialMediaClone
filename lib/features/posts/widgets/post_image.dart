import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../models/user_post.dart';
import 'asset_image_view.dart';

/// Aspect-ratio-constrained post image with a Hero transition.
class PostImage extends StatelessWidget {
  /// Creates an image for [post].
  const PostImage({required this.post, required this.aspectRatio, super.key});

  /// Post providing the image path and animation identity.
  final UserPost post;

  /// Display aspect ratio.
  final double aspectRatio;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSizes.pagePadding),
    child: Hero(
      tag: 'post-image-${post.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.imageRadius),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: AssetImageView(
            path: post.imagePath,
            icon: Icons.landscape_rounded,
          ),
        ),
      ),
    ),
  );
}
