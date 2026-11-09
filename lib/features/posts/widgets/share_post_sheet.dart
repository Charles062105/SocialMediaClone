import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/feedback.dart';

/// Simple share sheet that copies a post caption.
class SharePostSheet extends StatelessWidget {
  /// Creates the share sheet for [caption].
  const SharePostSheet({
    required this.caption,
    required this.onCopied,
    super.key,
  });

  /// Text copied when the user selects the action.
  final String caption;

  /// Called after the caption is copied.
  final VoidCallback onCopied;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Wrap(
      children: [
        ListTile(
          title: const Text(AppStrings.sharePost),
          leading: const Icon(Icons.ios_share_rounded),
        ),
        ListTile(
          leading: const Icon(Icons.copy_rounded),
          title: const Text(AppStrings.copyCaption),
          onTap: () async {
            try {
              await Clipboard.setData(ClipboardData(text: caption));
              if (!context.mounted) return;
              Navigator.of(context).pop();
              onCopied();
            } catch (error, stackTrace) {
              debugPrint(
                'TIKTOKTOK: Could not copy post caption: '
                '$error\n$stackTrace',
              );
              if (!context.mounted) return;
              AppFeedback.showError(context, AppStrings.shareFailed);
            }
          },
        ),
      ],
    ),
  );
}

/// Opens the post caption share sheet.
Future<void> showPostShareSheet(
  BuildContext context, {
  required String caption,
  required VoidCallback onCopied,
}) => showModalBottomSheet<void>(
  context: context,
  builder: (context) => SharePostSheet(caption: caption, onCopied: onCopied),
);
