import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';

/// Post actions for liking, commenting, and sharing.
class PostActionBar extends StatelessWidget {
  /// Creates the post action bar.
  const PostActionBar({
    required this.isLiked,
    required this.likeCount,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    super.key,
  });

  /// Whether this viewer liked the post.
  final bool isLiked;

  /// Current post like total.
  final int likeCount;

  /// Toggles the post like.
  final VoidCallback onLike;

  /// Focuses the comment composer.
  final VoidCallback onComment;

  /// Opens post sharing options.
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: AppSizes.pagePadding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Action(
          icon: isLiked ? Icons.favorite_rounded : Icons.favorite_border,
          label: '${AppStrings.like} ${formatCount(likeCount)}',
          color: isLiked ? Theme.of(context).colorScheme.tertiary : null,
          isSelected: isLiked,
          onTap: onLike,
        ),
        _Action(
          icon: Icons.mode_comment_outlined,
          label: AppStrings.comment,
          onTap: onComment,
        ),
        _Action(
          icon: Icons.ios_share_rounded,
          label: AppStrings.share,
          onTap: onShare,
        ),
      ],
    ),
  );
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final Color? color;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onTap,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedScale(
          scale: isSelected ? 1.2 : 1,
          duration: AppSizes.scrollDuration,
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: AppSizes.smallGap),
        Text(label, style: TextStyle(color: color)),
      ],
    ),
  );
}
