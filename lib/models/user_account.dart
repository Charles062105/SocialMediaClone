import 'friend.dart';
import 'user_post.dart';

/// Immutable account information and profile content.
class UserAccount {
  /// Creates an account with immutable friend and post collections.
  UserAccount({
    required this.name,
    required this.email,
    required this.avatarPath,
    required this.followers,
    required this.following,
    required List<Friend> friends,
    required List<UserPost> posts,
  }) : friends = List.unmodifiable(friends),
       posts = List.unmodifiable(posts);

  /// Account display name.
  final String name;

  /// Account email address.
  final String email;

  /// Bundled profile image path.
  final String avatarPath;

  /// Follower total.
  final int followers;

  /// Following total.
  final int following;

  /// Profile friend records.
  final List<Friend> friends;

  /// Profile posts.
  final List<UserPost> posts;

  /// Copies this account with selected values replaced.
  UserAccount copyWith({
    String? name,
    String? email,
    String? avatarPath,
    int? followers,
    int? following,
    List<Friend>? friends,
    List<UserPost>? posts,
  }) => UserAccount(
    name: name ?? this.name,
    email: email ?? this.email,
    avatarPath: avatarPath ?? this.avatarPath,
    followers: followers ?? this.followers,
    following: following ?? this.following,
    friends: friends ?? this.friends,
    posts: posts ?? this.posts,
  );
}
