import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';

/// Displays formatted follower, following, and post totals.
class StatsRow extends StatelessWidget {
  /// Creates a stats row from integer totals.
  const StatsRow({
    required this.followers,
    required this.following,
    required this.posts,
    super.key,
  });

  /// Number of followers.
  final int followers;

  /// Number of followed accounts.
  final int following;

  /// Number of posts.
  final int posts;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.fromLTRB(
      AppSizes.pagePadding,
      0,
      AppSizes.pagePadding,
      AppSizes.cardGap,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.cardGap),
      child: Row(
        children: [
          _Stat(value: formatCount(followers), label: AppStrings.followers),
          _Stat(value: formatCount(following), label: AppStrings.following),
          _Stat(value: formatCount(posts), label: AppStrings.posts),
        ],
      ),
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    ),
  );
}
