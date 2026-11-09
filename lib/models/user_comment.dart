/// A comment attached to a post.
class UserComment {
  /// Creates an immutable comment.
  const UserComment({
    required this.id,
    required this.author,
    required this.avatarPath,
    required this.text,
    required this.time,
    required this.createdAtMillis,
    this.likes = 0,
    this.isLiked = false,
  });

  /// Stable comment identifier.
  final String id;

  /// Comment author.
  final String author;

  /// Bundled author-avatar asset path.
  final String avatarPath;

  /// Comment text.
  final String text;

  /// Human-readable comment time.
  final String time;

  /// Creation timestamp used for sorting.
  final int createdAtMillis;

  /// Number of likes.
  final int likes;

  /// Whether the current viewer liked this comment.
  final bool isLiked;

  /// Copies this comment with updated like state.
  UserComment copyWith({int? likes, bool? isLiked}) => UserComment(
    id: id,
    author: author,
    avatarPath: avatarPath,
    text: text,
    time: time,
    createdAtMillis: createdAtMillis,
    likes: likes ?? this.likes,
    isLiked: isLiked ?? this.isLiked,
  );

  /// Converts this comment to JSON-compatible data.
  Map<String, Object> toJson() => {
    'id': id,
    'author': author,
    'avatarPath': avatarPath,
    'text': text,
    'time': time,
    'createdAtMillis': createdAtMillis,
    'likes': likes,
    'isLiked': isLiked,
  };

  /// Creates a comment from validated JSON data.
  factory UserComment.fromJson(Map<String, dynamic> json) {
    if (json['id'] is! String ||
        json['author'] is! String ||
        json['avatarPath'] is! String ||
        json['text'] is! String ||
        json['time'] is! String ||
        json['createdAtMillis'] is! int ||
        (json['likes'] != null && json['likes'] is! int) ||
        (json['isLiked'] != null && json['isLiked'] is! bool)) {
      throw const FormatException('A saved comment has invalid fields.');
    }
    return UserComment(
      id: json['id'] as String,
      author: json['author'] as String,
      avatarPath: json['avatarPath'] as String,
      text: json['text'] as String,
      time: json['time'] as String,
      createdAtMillis: json['createdAtMillis'] as int,
      likes: json['likes'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }
}
