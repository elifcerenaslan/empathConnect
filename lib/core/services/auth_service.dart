import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Şu anki kullanıcıyı stream olarak al
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Şu anki kullanıcı bilgisi
  User? get currentUser => _auth.currentUser;

  // E-posta ve şifre ile kayıt
  Future<UserModel?> signUpWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = credential.user;
      if (user != null) {
        // Firestore'a kullanıcıyı kaydet
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          username: username,
          createdAt: DateTime.now(),
          profileImageUrl: 'https://ui-avatars.com/api/?name=${username.replaceAll(' ', '+')}', // Varsayılan avatar
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        return newUser;
      }
    } catch (e) {
      print("Kayıt Hatası: \$e");
      rethrow;
    }
    return null;
  }

  // E-posta ve şifre ile giriş
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print("Giriş Hatası: \$e");
      rethrow;
    }
  }

  // Çıkış yap
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Şifre sıfırlama e-postası gönder
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Firestore'dan kullanıcı detaylarını getir
  Future<UserModel?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      print("Kullanıcı Detayı Alma Hatası: \$e");
    }
    return null;
  }
}
