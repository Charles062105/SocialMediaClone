import 'package:social_media/model/account.dart';
import 'package:social_media/model/friend.dart';
import 'package:social_media/model/usercomment.dart';
import 'package:social_media/model/userpost.dart';

class Userdata {
  // USER POSTS
  List<UserPost> userlist = [
    UserPost(
      userImg: "assets/profile_charles.png",
      username: "Charles Mike L. Quimado",
      time: "2 hours ago",
      postcontent: "Taking in a peaceful sunrise.",
      postimg: "assets/post_sunrise.jpg",
      numcommnets: "10",
      numshare: "5",
      isLiked: true,
    ),

    UserPost(
      userImg: "assets/profile_charles.png",
      username: "Charles Mike L. Quimado",
      time: "3 hours ago",
      postcontent: "A quiet moment by the lake.",
      postimg: "assets/post_lake.jpg",
      numcommnets: "20",
      numshare: "8",
      isLiked: false,
    ),

    UserPost(
      userImg: "assets/profile_charles.png",
      username: "Charles Mike L. Quimado",
      time: "5 hours ago",
      postcontent: "Fresh air and a little sunshine.",
      postimg: "assets/post_fresh.jpg",
      numcommnets: "15",
      numshare: "3",
      isLiked: true,
    ),
  ];

  // FRIEND LIST
  List<Friend> friendlist = [
    Friend(name: "Johnny Sins", imagePath: "assets/friend_johnny.png"),

    Friend(name: "Manny Pacquiao", imagePath: "assets/friend_manny.png"),

    Friend(name: "Mia Khalifa", imagePath: "assets/friend_mia.png"),

    Friend(name: "Jeo Ong", imagePath: "assets/friend_jeo.png"),

    Friend(name: "Peter Parker", imagePath: "assets/friend_peter.png"),

    Friend(name: "Ethan Mafia", imagePath: "assets/friend_ethan.png"),
  ];

  // COMMENT LIST
  List<UserComment> commentlist = [
    UserComment(
      commenterImg: "assets/friend_ethan.png",
      commenterName: "Ethan",
      commentTime: "1 hour ago",
      commenterContent: "This is a sample comment.",
    ),

    UserComment(
      commenterImg: "assets/friend_mia.png",
      commenterName: "Olivia",
      commentTime: "2 hours ago",
      commenterContent: "This is another sample comment.",
    ),
  ];

  // USER ACCOUNT
  Account myUserAccount = Account(
    name: "Charles Mike L. Quimado",
    email: "mike@gmail.com",
    img: "assets/profile_charles.png",
    numFollowers: "1B",
    numFollowing: "12.8K",
    numPosts: "3",
    numfriends: "6",
  );
}
