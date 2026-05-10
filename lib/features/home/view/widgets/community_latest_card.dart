import 'package:flutter/material.dart';
import '../../../../core/services/community_service.dart';
import '../../../../models/post_model.dart';
import '../../../community/view/community_view.dart';

class CommunityLatestCard extends StatelessWidget {
  const CommunityLatestCard({super.key});

  @override
  Widget build(BuildContext context) {
    final CommunityService communityService = CommunityService();

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CommunityView()),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(minHeight: 160),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.people,
                    color: Color(0xFF9C27B0), // Match other cards
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Topluluk',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 20, // Match other cards
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              StreamBuilder<List<PostModel>>(
                stream: communityService.getPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      'Yükleniyor...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                    );
                  }

                  if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text(
                      'Henüz mesaj yok',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                    );
                  }

                  final latestPost = snapshot.data!.first;

                  return Text(
                    '${latestPost.username}: ${latestPost.caption}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Git →',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Color(0xFFCFF1EF), // Match other cards
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    color: Color(0xFFCFF1EF),
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
