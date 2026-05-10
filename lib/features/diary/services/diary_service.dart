import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../data/models/diary_entry.dart';

class DiaryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Mevcut kullanıcının günlüklerini getiren Stream
  Stream<List<DiaryEntry>> getUserEntries() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('diaryEntries')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => DiaryEntry.fromMap(doc.data())).toList();
    });
  }

  // Yeni günlük ekleme
  Future<void> addEntry(DiaryEntry entry) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Kullanıcı girişi yapılmamış.');

    // Kendi userID'mizi zorla yazalım (güvenlik için)
    final entryToSave = DiaryEntry(
      id: entry.id,
      userId: user.uid,
      emotion: entry.emotion,
      moodScore: entry.moodScore,
      content: entry.content,
      createdAt: entry.createdAt,
      imageUrl: entry.imageUrl,
    );

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('diaryEntries')
        .doc(entry.id)
        .set(entryToSave.toMap());
  }

  // Fotoğrafı Storage'a yükleyip URL'sini döndürme
  Future<String?> uploadImage(File imageFile, String entryId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Kullanıcı girişi yapılmamış.');

    try {
      final ref = _storage.ref().child('diary_images/${user.uid}/$entryId.jpg');
      
      // Upload task
      final uploadTask = await ref.putFile(imageFile);
      
      // Get URL
      final url = await uploadTask.ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Resim yükleme hatası: $e');
      return null;
    }
  }

  // Günlük silme
  Future<void> deleteEntry(String entryId, String? imageUrl) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Firestore'dan sil
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('diaryEntries')
        .doc(entryId)
        .delete();

    // Storage'dan resmi sil
    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final ref = _storage.refFromURL(imageUrl);
        await ref.delete();
      } catch (e) {
        print('Resim silinirken hata oluştu: $e');
      }
    }
  }
}
