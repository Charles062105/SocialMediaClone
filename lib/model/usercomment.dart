class UserComment {
  UserComment({
    required this.commenterImg,
    required this.commenterName,
    required this.commentTime,
    required this.commenterContent,
    this.isLiked = false,
    List<String>? replies,
  }) : replies = replies ?? [];

  final String commenterImg;
  final String commenterName;
  final String commentTime;
  final String commenterContent;
  bool isLiked;
  final List<String> replies;
}
