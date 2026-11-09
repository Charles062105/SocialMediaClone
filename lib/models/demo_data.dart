import '../core/constants/app_assets.dart';
import 'friend.dart';
import 'user_account.dart';
import 'user_comment.dart';
import 'user_post.dart';

/// Demo profile data bundled with the application.
abstract final class DemoData {
  /// Friends in the order requested by the account owner.
  static const friends = <Friend>[
    Friend(name: 'Johnny Sins', imagePath: AppAssets.johnny),
    Friend(name: 'Manny Pacquiao', imagePath: AppAssets.manny),
    Friend(name: 'Mia Khalifa', imagePath: AppAssets.mia),
    Friend(name: 'Jeo Ong', imagePath: AppAssets.jeo),
    Friend(name: 'Peter Parker', imagePath: AppAssets.peter),
    Friend(name: 'Ethan Mafia', imagePath: AppAssets.ethan),
  ];

  /// Example feed with at least one million likes on each post.
  static final posts = <UserPost>[
    UserPost(
      id: 'charles-post-1',
      imagePath: AppAssets.sunrise,
      caption: 'A quiet morning, thoughtfully spent.',
      time: '2 hours ago',
      likes: 1200000,
      defaultComments: [
        UserComment(
          id: 'charles-post-1-comment-1',
          author: friends[1].name,
          avatarPath: friends[1].imagePath,
          text: 'This looks like such a lovely day!',
          time: '1 hour ago',
          createdAtMillis: 1794141600000,
          likes: 4,
        ),
        UserComment(
          id: 'charles-post-1-comment-2',
          author: friends[0].name,
          avatarPath: friends[0].imagePath,
          text: 'Love this shot.',
          time: '45 min ago',
          createdAtMillis: 1794142500000,
          likes: 2,
        ),
      ],
    ),
    UserPost(
      id: 'charles-post-2',
      imagePath: AppAssets.lake,
      caption: 'An afternoon by the water.',
      time: 'Yesterday',
      likes: 2400000,
      defaultComments: [
        UserComment(
          id: 'charles-post-2-comment-1',
          author: friends[2].name,
          avatarPath: friends[2].imagePath,
          text: 'Saving this for the next get-together.',
          time: 'Yesterday',
          createdAtMillis: 1794055200000,
          likes: 3,
        ),
      ],
    ),
    UserPost(
      id: 'charles-post-3',
      imagePath: AppAssets.fresh,
      caption: 'A fresh perspective on everyday dining.',
      time: '3 days ago',
      likes: 1050000,
      defaultComments: [],
    ),
  ];

  /// Example social profile and its statistics.
  static final account = UserAccount(
    name: 'Charles Mike L. Quimado',
    email: 'mike@gmail.com',
    avatarPath: AppAssets.profile,
    followers: 1000000000,
    following: 12800,
    friends: friends,
    posts: posts,
  );
}
