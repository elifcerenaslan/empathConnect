import 'package:flutter/material.dart';

class CommunityPost {
  final String id;
  final String avatar;
  final String userName;
  final DateTime createdAt;
  final bool isAnonymous;
  final String content;
  bool isLiked;
  int likes;
  int comments;

  CommunityPost({
    required this.id,
    required this.avatar,
    required this.userName,
    required this.createdAt,
    required this.isAnonymous,
    required this.content,
    this.isLiked = false,
    this.likes = 0,
    this.comments = 0,
  });
}

class CommunityController extends ChangeNotifier {
  final TextEditingController postTextController = TextEditingController();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAnonymous = false;
  bool get isAnonymous => _isAnonymous;

  final List<CommunityPost> _posts = [];
  List<CommunityPost> get posts => _posts;

  void toggleAnonymous() {
    _isAnonymous = !_isAnonymous;
    notifyListeners();
  }

  void addPost() {
    if (postTextController.text.trim().isEmpty) return;

    _isLoading = true;
    notifyListeners();

    // Simulate network delay or backend integration
    Future.delayed(const Duration(milliseconds: 500), () {
      final newPost = CommunityPost(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        avatar: _isAnonymous ? '?' : 'E',
        userName: _isAnonymous ? 'Anonim Kullanıcı' : 'Kullanıcı',
        createdAt: DateTime.now(),
        isAnonymous: _isAnonymous,
        content: postTextController.text.trim(),
      );

      _posts.insert(0, newPost);
      postTextController.clear();
      _isLoading = false;
      notifyListeners();
    });
  }

  void toggleLike(String id) {
    final index = _posts.indexWhere((post) => post.id == id);
    if (index != -1) {
      _posts[index].isLiked = !_posts[index].isLiked;
      if (_posts[index].isLiked) {
        _posts[index].likes++;
      } else {
        _posts[index].likes--;
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    postTextController.dispose();
    super.dispose();
  }
}
