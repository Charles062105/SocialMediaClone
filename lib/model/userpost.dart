import 'package:social_media/model/usercomment.dart';

class UserPost {
  final String userImg;
  final String username;
  final String time;
  final String postcontent;
  final String postimg;
  String numcommnets;
  final String numshare;
  bool isLiked;
  final List<UserComment> comments;

  UserPost({
    required this.userImg,
    required this.username,
    required this.time,
    required this.postcontent,
    required this.postimg,
    required this.numcommnets,
    required this.numshare,
    this.isLiked = false,
    List<UserComment>? comments,
  }) : comments = comments ?? [];
}
