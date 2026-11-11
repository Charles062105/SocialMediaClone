import 'package:flutter/material.dart';
import 'package:social_media/model/usercomment.dart';
import 'package:social_media/model/userdata.dart';
import 'package:social_media/model/userpost.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key, required this.userPost});

  final UserPost userPost;

  final Userdata userData = Userdata();

  final nameTxtStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  final boldTxtStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  Future<String?> replyDialog(BuildContext context) async {
    final formKey = GlobalKey<FormFieldState<String>>();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reply to comment'),
        content: TextFormField(
          key: formKey,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Write a reply'),
          onFieldSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, formKey.currentState?.value ?? ''),
            child: const Text('Reply'),
          ),
        ],
      ),
    );
  }

  Widget commentBtn(BuildContext context, UserComment userComment) =>
      StatefulBuilder(
        builder: (context, setState) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(userComment.commentTime),
                  const SizedBox(width: 15),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        userComment.isLiked = !userComment.isLiked;
                      });
                    },
                    child: Text(
                      userComment.isLiked ? 'Liked' : 'Like',
                      style: TextStyle(
                        color: userComment.isLiked ? Colors.blue : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  TextButton(
                    onPressed: () async {
                      final reply = await replyDialog(context);
                      if (reply != null && reply.trim().isNotEmpty) {
                        setState(() {
                          userComment.replies.add(reply.trim());
                        });
                      }
                    },
                    child: const Text('Reply'),
                  ),
                ],
              ),
            ),
            ...userComment.replies.map(
              (reply) => Padding(
                padding: const EdgeInsets.only(left: 30, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('You: $reply'),
                ),
              ),
            ),
          ],
        ),
      );

  Widget commentDesc(UserComment userComment) => Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(userComment.commenterName, style: nameTxtStyle),
        const SizedBox(height: 5),
        Text(userComment.commenterContent),
      ],
    ),
  );

  Widget commentSpace(UserComment userComment) => Container(
    decoration: const BoxDecoration(
      color: Color.fromARGB(35, 158, 158, 158),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: commentDesc(userComment),
  );

  Widget commenterPic(UserComment userComment) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: CircleAvatar(backgroundImage: AssetImage(userComment.commenterImg)),
  );

  Widget userCommentLine(
    BuildContext context,
    UserComment userPost,
    UserComment userComment,
  ) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      commenterPic(userComment),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [commentSpace(userComment), commentBtn(context, userComment)],
      ),
    ],
  );

  Widget userCommentDetails(BuildContext context, UserComment userComment) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          userCommentLine(context, userComment, userComment),
        ],
      );

  Widget commenters() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      const Divider(color: Colors.grey),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Text('All Comments', style: boldTxtStyle),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    ],
  );

  Widget buttons() => Column(
    children: [
      const Divider(color: Colors.grey),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              onPressed: () {},
              icon: const Icon(Icons.thumb_up, size: 20),
              label: const Text('Like'),
            ),

            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              onPressed: () {},
              icon: const Icon(Icons.comment, size: 20),
              label: const Text('Comment'),
            ),

            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              onPressed: () {},
              icon: const Icon(Icons.share, size: 20),
              label: const Text('Share'),
            ),
          ],
        ),
      ),
    ],
  );

  Widget userLine(UserPost userPost) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CircleAvatar(
          backgroundImage: AssetImage(userPost.userImg),
          radius: 20,
        ),
      ),

      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(userPost.username, style: nameTxtStyle),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(userPost.time),
              const Text(','),
              const Icon(Icons.group, size: 15, color: Colors.grey),
            ],
          ),
        ],
      ),
    ],
  );

  Widget postImage(UserPost userPost) => Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        Row(children: [Text(userPost.postcontent)]),

        const SizedBox(height: 15),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            userPost.postimg,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
        ),
      ),

      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          userLine(userPost),
          postImage(userPost),
          buttons(),
          commenters(),

          ...userData.commentlist.map(
            (userComment) => userCommentDetails(context, userComment),
          ),
        ],
      ),
    );
  }
}
