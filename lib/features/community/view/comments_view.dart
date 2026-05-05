import 'package:flutter/material.dart';
import '../../../../models/post_model.dart';
import '../../../../models/comment_model.dart';
import '../../../../core/services/community_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentsView extends StatefulWidget {
  final PostModel post;

  const CommentsView({super.key, required this.post});

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  final _commentController = TextEditingController();
  final CommunityService _communityService = CommunityService();
  bool _isPosting = false;

  void _postComment() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _isPosting = true;
    });

    try {
      await _communityService.addComment(
        widget.post.id,
        _commentController.text.trim(),
      );
      _commentController.clear();
      FocusScope.of(context).unfocus();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yorum eklenemedi: \${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yorumlar'),
      ),
      body: Column(
        children: [
          // Yorum Listesi
          Expanded(
            child: StreamBuilder<List<CommentModel>>(
              stream: _communityService.getComments(widget.post.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Yorumlar yüklenirken bir hata oluştu.'));
                }

                final comments = snapshot.data;

                if (comments == null || comments.isEmpty) {
                  return const Center(
                    child: Text(
                      'Henüz yorum yok. İlk yorumu sen yap!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: comment.userProfileImage.isNotEmpty
                            ? NetworkImage(comment.userProfileImage)
                            : null,
                        child: comment.userProfileImage.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(
                        comment.username,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment.text, style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(
                            timeago.format(comment.createdAt, locale: 'en'), // Normalde 'tr' eklenebilir
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          // Yorum Ekleme Alanı
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -1),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Yorum ekle...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _isPosting
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send),
                          color: Theme.of(context).colorScheme.primary,
                          onPressed: _postComment,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
