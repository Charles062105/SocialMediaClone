import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';

/// Section heading with an optional content count.
class ProfileSectionTitle extends StatelessWidget {
  /// Creates a section title.
  const ProfileSectionTitle({
    required this.title,
    required this.count,
    super.key,
  });

  /// Section title.
  final String title;

  /// Number of items in the section.
  final int count;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSizes.sectionInset,
      AppSizes.pagePadding / 2,
      AppSizes.sectionInset,
      AppSizes.cardGap,
    ),
    child: Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        const Spacer(),
        Text('$count'),
      ],
    ),
  );
}
