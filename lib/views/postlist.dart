import 'package:flutter/material.dart';
import 'package:social_media/model/userdata.dart';
import 'package:social_media/model/userpost.dart';
import 'package:social_media/views/profile_view.dart';

class Postlist extends StatefulWidget {
  const Postlist({super.key, required this.userdata});

  final Userdata userdata;

  @override
  State<Postlist> createState() => _PostlistState();
}

class _PostlistState extends State<Postlist> {
  final nametxtStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  void gotoPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Widget buttons(UserPost userPost) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: userPost.isLiked ? Colors.blue : Colors.grey,
        ),
        onPressed: () {
          setState(() {
            userPost.isLiked = !userPost.isLiked;
          });
        },
        icon: const Icon(Icons.thumb_up),
        label: const Text('Like'),
      ),

      TextButton.icon(
        style: TextButton.styleFrom(foregroundColor: Colors.grey),
        onPressed: () {},
        icon: const Icon(Icons.message),
        label: const Text('Comment'),
      ),

      TextButton.icon(
        style: TextButton.styleFrom(foregroundColor: Colors.grey),
        onPressed: () {},
        icon: const Icon(Icons.share),
        label: const Text('Share'),
      ),
    ],
  );

  Widget postCount(UserPost userPost) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Text('${userPost.numcommnets} comments'),
      const SizedBox(width: 20),
      Text('${userPost.numshare} shares'),
    ],
  );

  Widget postImage(UserPost userPost) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        userPost.postimg,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
      ),
    ),
  );

  Widget postHeader(UserPost userPost) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: CircleAvatar(
          backgroundImage: AssetImage(userPost.userImg),
          radius: 20,
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(userPost.username, style: nametxtStyle),

          Row(
            children: [
              Text(userPost.time),
              const SizedBox(width: 4),
              const Icon(Icons.people, size: 16),
            ],
          ),
        ],
      ),
      const Spacer(),
      const Icon(Icons.more_horiz),
    ],
  );

  Widget showPost(UserPost userPost) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      postHeader(userPost),

      if (userPost.postcontent.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(userPost.postcontent),
        ),
      postImage(userPost),
      postCount(userPost),
      const Divider(),
      buttons(userPost),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.userdata.userlist.map((userPost) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              gotoPage(context, ProfileView(userPost: userPost));
            },
            child: showPost(userPost),
          ),
        );
      }).toList(),
    );
  }
}
