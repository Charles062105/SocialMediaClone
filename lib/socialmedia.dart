import 'package:flutter/material.dart';
import 'package:social_media/model/userdata.dart';
import 'package:social_media/views/infoheader.dart';
import 'package:social_media/views/mainheader.dart';
import 'package:social_media/views/friendlist.dart';
import 'package:social_media/views/postlist.dart';

class SocialMedia extends StatefulWidget {
  const SocialMedia({super.key});

  @override
  State<SocialMedia> createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  Userdata userdata = Userdata();

  var followTxtStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TIKTOKTOK',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF5F5F5),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 8),
          Mainheader(userdata: userdata),
          Infoheader(userdata: userdata),
          Friendlist(userdata: userdata),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 12),
            child: Row(
              children: [
                Text('Posts', style: followTxtStyle),
                const Spacer(),
                Text('${userdata.userlist.length}'),
              ],
            ),
          ),
          Postlist(userdata: userdata),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
