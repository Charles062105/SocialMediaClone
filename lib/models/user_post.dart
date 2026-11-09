import 'user_comment.dart';

/// A post shown in the profile and post detail screens.
class UserPost {
  /// Creates a post record with an immutable default-comment list.
  UserPost({
    required this.id,
    required this.imagePath,
    required this.caption,
    required this.time,
    required this.likes,
    required List<UserComment> defaultComments,
  }) : defaultComments = List.unmodifiable(defaultComments);

  /// Stable post identifier.
  final String id;

  /// Bundled post-image asset path.
  final String imagePath;

  /// Post caption.
  final String caption;

  /// Human-readable post time.
  final String time;

  /// Initial demo like count.
  final int likes;

  /// Default comments merged with locally saved comments.
  final List<UserComment> defaultComments;

  /// Copies this post with selected values replaced.
  UserPost copyWith({
    String? id,
    String? imagePath,
    String? caption,
    String? time,
    int? likes,
    List<UserComment>? defaultComments,
  }) => UserPost(
    id: id ?? this.id,
    imagePath: imagePath ?? this.imagePath,
    caption: caption ?? this.caption,
    time: time ?? this.time,
    likes: likes ?? this.likes,
    defaultComments: defaultComments ?? this.defaultComments,
  );
}
