import 'package:flutter/material.dart';
import 'package:social_media/model/userdata.dart';

class Infoheader extends StatelessWidget {
  const Infoheader({super.key, required this.userdata});

  final Userdata userdata;

  static const followTxtStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    final stats = [
      ("Followers", userdata.myUserAccount.numFollowers),
      ("Following", userdata.myUserAccount.numFollowing),
      ("Posts", userdata.myUserAccount.numPosts),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats
            .map(
              (stat) => Column(
                children: [
                  Text(stat.$2, style: followTxtStyle),
                  const SizedBox(height: 2),
                  Text(stat.$1),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
