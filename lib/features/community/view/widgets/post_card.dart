import 'package:flutter/material.dart';
import '../../../../models/post_model.dart';
import '../../../../core/services/community_service.dart';
import '../../../../core/services/auth_service.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final CommunityService _communityService = CommunityService();
  final AuthService _authService = AuthService();

  PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final currentUserId = _authService.currentUser?.uid;
    final isLiked = post.likes.contains(currentUserId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (User info)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: post.userProfileImage.isNotEmpty
                      ? NetworkImage(post.userProfileImage)
                      : null,
                  child: post.userProfileImage.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 12),
                Text(
                  post.username,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          
          // Image
          if (post.imageUrl.isNotEmpty)
            Image.network(
              post.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : null,
                  ),
                  onPressed: () {
                    _communityService.toggleLike(post.id, post.likes);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {
                    // Yorum sayfasına git (TODO)
                  },
                ),
              ],
            ),
          ),

          // Likes Count & Caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\${post.likes.length} beğenme',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                        text: '\${post.username} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: post.caption),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
