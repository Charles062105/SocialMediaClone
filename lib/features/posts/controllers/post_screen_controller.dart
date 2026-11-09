import 'package:flutter/foundation.dart';

import '../../../models/user_comment.dart';
import '../../../models/user_post.dart';
import 'comments_controller.dart';
import '../comment_sort_order.dart';

/// Coordinates post-level UI state with persistent comment state.
class PostScreenController extends ChangeNotifier {
  /// Creates a controller for one post's interactions.
  PostScreenController({required this.comments, required UserPost post})
    : _likeCount = post.likes {
    comments.addListener(_notify);
  }

  /// Persistent comment state for this post.
  final CommentsController comments;

  int _likeCount;
  bool _isLiked = false;
  CommentSortOrder _sortOrder = CommentSortOrder.newest;
  bool _isSending = false;
  UserComment? _lastDeleted;
  bool _disposed = false;

  /// Current total of likes on the post.
  int get likeCount => _likeCount;

  /// Whether this viewer liked the post.
  bool get isLiked => _isLiked;

  /// Current comment sort order.
  CommentSortOrder get sortOrder => _sortOrder;

  /// Whether a comment is being saved.
  bool get isSending => _isSending;

  /// The most recently deleted comment available for Undo.
  UserComment? get lastDeleted => _lastDeleted;

  /// Loads and merges the saved comments.
  Future<void> load() async {
    await comments.load();
    _notify();
  }

  /// Adds a comment and switches the list to newest-first after success.
  Future<bool> addComment(String text) async {
    if (_isSending) return false;
    _isSending = true;
    _notify();
    try {
      final saved = await comments.addComment(text);
      if (saved) _sortOrder = CommentSortOrder.newest;
      return saved;
    } finally {
      _isSending = false;
      _notify();
    }
  }

  /// Toggles the post like and updates its count.
  void togglePostLike() {
    _isLiked = !_isLiked;
    _likeCount += _isLiked ? 1 : -1;
    _notify();
  }

  /// Changes the visible comment ordering.
  void setSortOrder(CommentSortOrder value) {
    _sortOrder = value;
    _notify();
  }

  /// Returns comments sorted for display.
  List<UserComment> get sortedComments =>
      comments.sorted(newestFirst: _sortOrder == CommentSortOrder.newest);

  /// Toggles and persists a comment like.
  Future<bool> toggleCommentLike(String commentId) =>
      comments.toggleLike(commentId);

  /// Deletes a comment and stores it for a possible Undo.
  Future<bool> deleteComment(UserComment comment) async {
    final saved = await comments.deleteComment(comment);
    if (saved) _lastDeleted = comment;
    _notify();
    return saved;
  }

  /// Restores the most recently deleted comment.
  Future<bool> restoreLastDeleted() async {
    final comment = _lastDeleted;
    if (comment == null) return false;
    final restored = await comments.restoreComment(comment);
    if (restored) _lastDeleted = null;
    _notify();
    return restored;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    comments
      ..removeListener(_notify)
      ..dispose();
    super.dispose();
  }
}
