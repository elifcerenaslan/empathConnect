import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../models/post_model.dart';
import '../../../../core/services/community_service.dart';
import '../../../../core/services/auth_service.dart';
import '../comments_view.dart';

class PostCard extends StatefulWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final CommunityService _communityService = CommunityService();
  final AuthService _authService = AuthService();

  void _toggleLike() {
    HapticFeedback.selectionClick();
    _communityService.toggleLike(widget.post.id, widget.post.likes);
  }

  void _toggleRepost() {
    HapticFeedback.selectionClick();
    _communityService.toggleRepost(widget.post.id, widget.post.reposts);
  }

  void _deletePost() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gönderiyi Sil'),
        content: const Text('Bu gönderiyi silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _communityService.deletePost(widget.post.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gönderi silindi.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hata: \${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = _authService.currentUser?.uid;
    final isLiked = widget.post.likes.contains(currentUserId);
    final isReposted = widget.post.reposts.contains(currentUserId);
    final isOwner = currentUserId == widget.post.userId;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.12)),
          bottom: BorderSide(color: Colors.grey.withOpacity(0.12)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // Avatar
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.tertiary,
                        colorScheme.primary,
                      ],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: widget.post.userProfileImage.isNotEmpty
                          ? NetworkImage(widget.post.userProfileImage)
                          : null,
                      backgroundColor: colorScheme.primary.withOpacity(0.2),
                      child: widget.post.userProfileImage.isEmpty
                          ? Icon(Icons.person, size: 18, color: colorScheme.primary)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.username,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      Text(
                        timeago.format(widget.post.createdAt, locale: 'en'),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isOwner)
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.grey.shade500),
                    onPressed: _deletePost,
                    visualDensity: VisualDensity.compact,
                  )
                else
                  IconButton(
                    icon: Icon(Icons.more_horiz, color: Colors.grey.shade500),
                    onPressed: () {},
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ),

          // ── Sadece metin gönderisi ──────────────
          if (widget.post.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                widget.post.text,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),

          // ── Aksiyon Butonları ──────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Yorum
                _ActionButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: '',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentsView(post: widget.post),
                      ),
                    );
                  },
                ),
                // Repost
                _ActionButton(
                  icon: isReposted ? Icons.repeat_on : Icons.repeat,
                  color: isReposted ? Colors.green : null,
                  label: widget.post.reposts.isNotEmpty
                      ? '\${widget.post.reposts.length}'
                      : '',
                  onTap: _toggleRepost,
                ),
                // Beğen
                _ActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.redAccent : null,
                  label: widget.post.likes.isNotEmpty
                      ? '\${widget.post.likes.length}'
                      : '',
                  onTap: _toggleLike,
                ),
                // Paylaş
                _ActionButton(
                  icon: Icons.share_outlined,
                  label: '',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Küçük aksiyon butonu widget'ı ─────────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 22, color: color ?? Colors.grey.shade600),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color ?? Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
