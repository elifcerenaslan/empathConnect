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

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  final CommunityService _communityService = CommunityService();
  final AuthService _authService = AuthService();

  late AnimationController _heartController;
  late Animation<double> _heartScale;
  bool _showHeartOverlay = false;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _heartScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() async {
    final currentUserId = _authService.currentUser?.uid;
    final isLiked = widget.post.likes.contains(currentUserId);

    if (!isLiked) {
      HapticFeedback.lightImpact();
      await _communityService.toggleLike(widget.post.id, widget.post.likes);
    }

    setState(() => _showHeartOverlay = true);
    _heartController.forward(from: 0.0).then((_) async {
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) {
        _heartController.reverse();
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) setState(() => _showHeartOverlay = false);
      }
    });
  }

  void _toggleLike() {
    HapticFeedback.selectionClick();
    _communityService.toggleLike(widget.post.id, widget.post.likes);
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = _authService.currentUser?.uid;
    final isLiked = widget.post.likes.contains(currentUserId);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                // Avatar ile gradient border
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
                IconButton(
                  icon: Icon(Icons.more_horiz, color: Colors.grey.shade500),
                  onPressed: () {},
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),

          // ── Görsel (çift tıkla beğen) ──────────────
          if (widget.post.imageUrl.isNotEmpty)
            GestureDetector(
              onDoubleTap: _handleDoubleTap,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    child: Image.network(
                      widget.post.imageUrl,
                      width: double.infinity,
                      height: 340,
                      fit: BoxFit.cover,
                      loadingBuilder: (ctx, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 340,
                          color: colorScheme.primary.withOpacity(0.05),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: colorScheme.primary,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (ctx, err, st) => Container(
                        height: 200,
                        color: colorScheme.primary.withOpacity(0.08),
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: colorScheme.primary,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                  // Kalp overlay animasyonu
                  if (_showHeartOverlay)
                    ScaleTransition(
                      scale: _heartScale,
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 100,
                        shadows: [
                          Shadow(blurRadius: 20, color: Colors.black38),
                        ],
                      ),
                    ),
                ],
              ),
            ),

          // Sadece metin gönderisi
          if (widget.post.imageUrl.isEmpty && widget.post.caption.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              color: colorScheme.primary.withOpacity(0.06),
              child: Text(
                widget.post.caption,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),

          // ── Aksiyon Butonları ──────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              children: [
                // Beğen
                _ActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.redAccent : null,
                  label: widget.post.likes.isNotEmpty
                      ? '${widget.post.likes.length}'
                      : '',
                  onTap: _toggleLike,
                ),
                const SizedBox(width: 4),
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
                const Spacer(),
                // Kaydet (placeholder)
                _ActionButton(
                  icon: Icons.bookmark_border_rounded,
                  label: '',
                  onTap: () {},
                ),
              ],
            ),
          ),

          // ── Beğeni sayısı ve Açıklama ──────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.post.likes.isNotEmpty)
                  Text(
                    '${widget.post.likes.length} beğenme',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                if (widget.post.imageUrl.isNotEmpty &&
                    widget.post.caption.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style.copyWith(
                            fontSize: 13.5,
                          ),
                      children: [
                        TextSpan(
                          text: '${widget.post.username} ',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: widget.post.caption),
                      ],
                    ),
                  ),
                ],
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
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 26, color: color),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
