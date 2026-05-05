import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/post_model.dart';
import 'auth_service.dart';

class CommunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  // Tüm gönderileri (akışı) getir
  Stream<List<PostModel>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PostModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Yeni gönderi paylaş
  Future<void> createPost(String caption, String imageUrl) async {
    try {
      final user = _authService.currentUser;
      if (user == null) throw Exception("Kullanıcı giriş yapmamış.");

      // Kullanıcı detaylarını al
      final userDetails = await _authService.getUserDetails(user.uid);
      
      final postRef = _firestore.collection('posts').doc();
      
      final newPost = PostModel(
        id: postRef.id,
        userId: user.uid,
        username: userDetails?.username ?? 'Bilinmeyen Kullanıcı',
        userProfileImage: userDetails?.profileImageUrl ?? '',
        imageUrl: imageUrl,
        caption: caption,
        likes: [],
        createdAt: DateTime.now(),
      );

      await postRef.set(newPost.toMap());
    } catch (e) {
      print("Gönderi Paylaşma Hatası: \$e");
      rethrow;
    }
  }

  // Gönderiyi beğen / beğenmekten vazgeç
  Future<void> toggleLike(String postId, List<String> currentLikes) async {
    try {
      final user = _authService.currentUser;
      if (user == null) return;

      final postRef = _firestore.collection('posts').doc(postId);

      if (currentLikes.contains(user.uid)) {
        await postRef.update({
          'likes': FieldValue.arrayRemove([user.uid])
        });
      } else {
        await postRef.update({
          'likes': FieldValue.arrayUnion([user.uid])
        });
      }
    } catch (e) {
      print("Beğeni Hatası: \$e");
    }
  }
}
