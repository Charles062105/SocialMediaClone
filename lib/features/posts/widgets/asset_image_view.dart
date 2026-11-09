import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';

/// Displays a bundled image with a fade and a failure placeholder.
class AssetImageView extends StatelessWidget {
  /// Creates an image view for a bundled asset.
  const AssetImageView({required this.path, required this.icon, super.key});

  /// Asset path.
  final String path;

  /// Icon displayed if the asset cannot be decoded.
  final IconData icon;

  @override
  Widget build(BuildContext context) => Image.asset(
    path,
    fit: BoxFit.cover,
    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
        AnimatedOpacity(
          opacity: wasSynchronouslyLoaded || frame != null ? 1 : 0,
          duration: AppSizes.fadeDuration,
          child: child,
        ),
    errorBuilder: (context, error, stackTrace) {
      debugPrint('TIKTOKTOK: Image "$path" failed: $error');
      return ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(icon, size: 36), Text(AppStrings.imageUnavailable)],
          ),
        ),
      );
    },
  );
}
