import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/constants/app_strings.dart';
import '../../../models/user_account.dart';
import '../../../models/user_comment.dart';
import '../../../models/user_post.dart';
import '../../../services/comment_storage_service.dart';

/// Manages a post's comment state and persistence.
class CommentsController extends ChangeNotifier {
  /// Creates a controller for one post.
  CommentsController({
    required UserPost post,
    required this.account,
    required this.storage,
  }) : _post = post,
       _comments = List<UserComment>.of(post.defaultComments);

  final UserPost _post;

  /// Account used as the author of new comments.
  final UserAccount account;

  /// Storage adapter used for persistence.
  final CommentStorageService storage;
  List<UserComment> _comments;
  final Set<String> _deletedIds = {};
  bool _isLoading = true;
  bool _disposed = false;
  String? _warning;

  /// Comments in creation order.
  List<UserComment> get comments => List.unmodifiable(_comments);

  /// Whether initial storage loading is active.
  bool get isLoading => _isLoading;

  /// A recoverable storage warning, if present.
  String? get warning => _warning;

  /// Loads saved comments and merges them with the post defaults.
  Future<void> load() async {
    try {
      final saved = await storage.load(_post.id);
      if (_disposed) return;
      final merged = <String, UserComment>{
        for (final comment in _post.defaultComments) comment.id: comment,
        for (final comment in saved?.comments ?? const <UserComment>[])
          comment.id: comment,
      };
      _deletedIds
        ..clear()
        ..addAll(saved?.deletedIds ?? const {});
      for (final id in _deletedIds) {
        merged.remove(id);
      }
      _comments = merged.values.toList();
    } on FormatException catch (error, stackTrace) {
      debugPrint('TIKTOKTOK: Invalid saved comments: $error\n$stackTrace');
      await _clearCorruptedStorage();
      _comments = List<UserComment>.of(_post.defaultComments);
      _deletedIds.clear();
      _warning = AppStrings.corruptedComments;
    } catch (error, stackTrace) {
      debugPrint('TIKTOKTOK: Could not load comments: $error\n$stackTrace');
      _comments = List<UserComment>.of(_post.defaultComments);
      _warning = AppStrings.commentLoadFailed;
    } finally {
      _isLoading = false;
      _notify();
    }
  }

  /// Adds a comment, rolling back if persistence fails.
  Future<bool> addComment(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || trimmed.length > 300 || _isLoading) return false;
    final now = DateTime.now();
    final comment = UserComment(
      id: now.microsecondsSinceEpoch.toString(),
      author: account.name,
      avatarPath: account.avatarPath,
      text: trimmed,
      time: AppStrings.justNow,
      createdAtMillis: now.millisecondsSinceEpoch,
    );
    _comments.insert(0, comment);
    _notify();
    final saved = await _persist();
    if (!saved) {
      _comments.removeWhere((item) => item.id == comment.id);
      _notify();
      return false;
    }
    return true;
  }

  /// Toggles a comment's like and persists the updated state.
  Future<bool> toggleLike(String commentId) async {
    final index = _comments.indexWhere((comment) => comment.id == commentId);
    if (index < 0) return false;
    final comment = _comments[index];
    final isLiked = !comment.isLiked;
    _comments[index] = comment.copyWith(
      isLiked: isLiked,
      likes: comment.likes + (isLiked ? 1 : -1),
    );
    _notify();
    if (await _persist()) return true;
    _comments[index] = comment;
    _notify();
    return false;
  }

  /// Deletes a comment and persists the removal.
  Future<bool> deleteComment(UserComment comment) async {
    final index = _comments.indexWhere((item) => item.id == comment.id);
    if (index < 0) return false;
    _comments.removeAt(index);
    _deletedIds.add(comment.id);
    _notify();
    if (await _persist()) return true;
    _deletedIds.remove(comment.id);
    _comments.insert(index.clamp(0, _comments.length).toInt(), comment);
    _notify();
    return false;
  }

  /// Restores a deleted comment and persists the change.
  Future<bool> restoreComment(UserComment comment) async {
    _deletedIds.remove(comment.id);
    if (!_comments.any((item) => item.id == comment.id)) {
      _comments.insert(0, comment);
    }
    _notify();
    if (await _persist()) return true;
    _comments.removeWhere((item) => item.id == comment.id);
    _deletedIds.add(comment.id);
    _notify();
    return false;
  }

  /// Sorts a copy of the current comments by creation time.
  List<UserComment> sorted({required bool newestFirst}) {
    final result = List<UserComment>.of(_comments);
    result.sort(
      (a, b) => newestFirst
          ? b.createdAtMillis.compareTo(a.createdAtMillis)
          : a.createdAtMillis.compareTo(b.createdAtMillis),
    );
    return result;
  }

  Future<bool> _persist() async {
    try {
      await storage.save(_post.id, _comments, _deletedIds);
      if (_disposed) return false;
      _warning = null;
      return true;
    } catch (error, stackTrace) {
      debugPrint('TIKTOKTOK: Could not save comments: $error\n$stackTrace');
      _warning = AppStrings.commentSaveFailed;
      return false;
    }
  }

  Future<void> _clearCorruptedStorage() async {
    try {
      await storage.clear(_post.id);
    } catch (error, stackTrace) {
      debugPrint(
        'TIKTOKTOK: Could not clear invalid comment data: '
        '$error\n$stackTrace',
      );
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
