import '../constants/app_strings.dart';

/// Formats profile statistics for compact display.
String formatCount(int value) {
  if (value >= 1000000000) {
    return '${(value / 1000000000).toStringAsFixed(value % 1000000000 == 0 ? 0 : 1)}B';
  }
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 1)}M';
  }
  if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}K';
  }
  return value.toString();
}

/// Returns a readable post-comment count.
String formatCommentCount(int value) =>
    '$value ${value == 1 ? AppStrings.commentCountSingular : AppStrings.commentCountPlural}';
