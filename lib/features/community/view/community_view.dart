import 'package:flutter/material.dart';
import '../../../core/services/community_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../models/post_model.dart';
import 'widgets/post_card.dart';
import 'create_post_view.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  final CommunityService _communityService = CommunityService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // ── AppBar ──────────────────────────────────────
      appBar: AppBar(
        titleSpacing: 16,
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [colorScheme.tertiary, colorScheme.primary],
          ).createShader(bounds),
          child: const Text(
            'Topluluk',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          // Yeni gönderi butonu
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreatePostView(),
                ),
              ),
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.tertiary, colorScheme.primary],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: Colors.grey.withOpacity(0.15),
          ),
        ),
      ),

      body: StreamBuilder<List<PostModel>>(
        stream: _communityService.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Bir hata oluştu: ${snapshot.error}'),
            );
          }

          final posts = snapshot.data ?? [];

          return CustomScrollView(
            slivers: [
              // ── Stories Şeridi ──────────────────────
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        itemCount: posts.length + 1, // +1 kendi story'si
                        itemBuilder: (ctx, i) {
                          if (i == 0) {
                            // Kendi Story Ekle
                            return _StoryAvatar(
                              label: 'Hikayeni\nEkle',
                              isAddButton: true,
                              colorScheme: colorScheme,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const CreatePostView()),
                              ),
                            );
                          }
                          final post = posts[i - 1];
                          return _StoryAvatar(
                            label: post.username,
                            imageUrl: post.userProfileImage,
                            colorScheme: colorScheme,
                            onTap: () {},
                          );
                        },
                      ),
                    ),
                    Divider(height: 1, color: Colors.grey.withOpacity(0.15)),
                  ],
                ),
              ),

              // ── Gönderi Akışı ───────────────────────
              if (posts.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 72,
                          color: colorScheme.primary.withOpacity(0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Henüz gönderi yok.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'İlk paylaşımı sen yap!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CreatePostView()),
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text('Gönderi Paylaş'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, index) => PostCard(post: posts[index]),
                    childCount: posts.length,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ── Story Avatarı ──────────────────────────────────────
class _StoryAvatar extends StatelessWidget {
  final String label;
  final String? imageUrl;
  final bool isAddButton;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _StoryAvatar({
    required this.label,
    required this.colorScheme,
    required this.onTap,
    this.imageUrl,
    this.isAddButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            // Gradient border
            Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isAddButton
                    ? null
                    : LinearGradient(
                        colors: [colorScheme.tertiary, colorScheme.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                border: isAddButton
                    ? Border.all(color: Colors.grey.shade300, width: 1.5)
                    : null,
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: colorScheme.primary.withOpacity(0.1),
                backgroundImage:
                    imageUrl != null && imageUrl!.isNotEmpty
                        ? NetworkImage(imageUrl!)
                        : null,
                child: isAddButton
                    ? Icon(Icons.add, color: colorScheme.primary, size: 24)
                    : (imageUrl == null || imageUrl!.isEmpty
                        ? Icon(Icons.person,
                            color: colorScheme.primary, size: 24)
                        : null),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(fontSize: 11),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
