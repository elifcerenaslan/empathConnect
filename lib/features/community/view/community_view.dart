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
              // ── Gönderi Akışı ───────────────────────
              if (posts.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
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
