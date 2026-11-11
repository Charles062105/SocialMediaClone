import 'package:flutter/material.dart';
import 'package:social_media/model/friend.dart';
import 'package:social_media/model/userdata.dart';

class Friendlist extends StatelessWidget {
  const Friendlist({super.key, required this.userdata});

  final Userdata userdata;

  static const followTxtStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  Widget friend(Friend friend) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 1.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                friend.imagePath,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            friend.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget friendListGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 150,
        crossAxisSpacing: 12,
        mainAxisSpacing: 10,
      ),
      padding: EdgeInsets.zero,
      itemCount: userdata.friendlist.length,
      itemBuilder: (context, index) {
        return friend(userdata.friendlist[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const Text("Friends", style: followTxtStyle),
              const Spacer(),
              Text("${userdata.friendlist.length}"),
            ],
          ),
        ),
        friendListGrid(),
      ],
    );
  }
}
