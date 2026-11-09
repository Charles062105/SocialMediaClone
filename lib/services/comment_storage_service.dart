import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_comment.dart';

/// Stores comments and deleted default-comment identifiers per post.
class CommentStorageService {
  /// Creates the storage adapter.
  CommentStorageService();

  late final Future<SharedPreferences> _store = SharedPreferences.getInstance();

  /// Loads comments and deletion records for one post.
  Future<StoredComments?> load(String postId) async {
    try {
      final preferences = await _store;
      final raw = preferences.getString(_key(postId));
      if (raw == null) return null;
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return StoredComments(
          comments: decoded.map(_decodeComment).toList(),
          deletedIds: const {},
        );
      }
      if (decoded is! Map || decoded['comments'] is! List) {
        throw const FormatException(
          'Saved comments are not a valid JSON object.',
        );
      }
      final comments = (decoded['comments'] as List)
          .map(_decodeComment)
          .toList();
      final rawDeleted = decoded['deletedIds'] ?? const <Object>[];
      if (rawDeleted is! List || rawDeleted.any((value) => value is! String)) {
        throw const FormatException('Deleted comment identifiers are invalid.');
      }
      return StoredComments(
        comments: comments,
        deletedIds: rawDeleted.cast<String>().toSet(),
      );
    } catch (error, stackTrace) {
      debugPrint(
        'TIKTOKTOK: Comment JSON/storage load failed: '
        '$error\n$stackTrace',
      );
      rethrow;
    }
  }

  /// Persists comment content and deleted default-comment identifiers.
  Future<void> save(
    String postId,
    List<UserComment> comments,
    Set<String> deletedIds,
  ) async {
    try {
      final encoded = jsonEncode({
        'comments': comments.map((comment) => comment.toJson()).toList(),
        'deletedIds': deletedIds.toList(),
      });
      final success = await (await _store).setString(_key(postId), encoded);
      if (!success) throw StateError('Comment storage rejected the write.');
    } catch (error, stackTrace) {
      debugPrint(
        'TIKTOKTOK: Comment JSON/storage save failed: '
        '$error\n$stackTrace',
      );
      rethrow;
    }
  }

  /// Removes invalid comment JSON from storage.
  Future<void> clear(String postId) async {
    try {
      await (await _store).remove(_key(postId));
    } catch (error, stackTrace) {
      debugPrint(
        'TIKTOKTOK: Could not clear saved comments: '
        '$error\n$stackTrace',
      );
      rethrow;
    }
  }

  UserComment _decodeComment(Object? item) {
    if (item is! Map) {
      throw const FormatException('A saved comment is not an object.');
    }
    try {
      return UserComment.fromJson(Map<String, dynamic>.from(item));
    } on TypeError catch (error) {
      throw FormatException('A saved comment has invalid fields: $error');
    }
  }

  String _key(String postId) => 'comments_$postId';
}

/// Stored post comments and user-deleted default comments.
class StoredComments {
  /// Creates an immutable stored comments result.
  const StoredComments({required this.comments, required this.deletedIds});

  /// Saved user and default comments.
  final List<UserComment> comments;

  /// Default comment identifiers removed by the user.
  final Set<String> deletedIds;
}
