import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:empath_connect/models/support_point.dart'; 

class SosProvider extends ChangeNotifier {
  List<SupportPoint> _points = [];
  bool _isLoading = false;

  List<SupportPoint> get points => _points;
  bool get isLoading => _isLoading;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- FİREBASE'DEN VERİLERİ DİNLE (GERÇEK ZAMANLI) ---
  // --- FİREBASE'DEN VERİLERİ DİNLE (GERÇEK ZAMANLI) ---
  Future<void> fetchSupportPoints() async {
    _isLoading = true;
    notifyListeners(); // Yüklenme ekranını başlat

    final user = _auth.currentUser;
    
    // 1. KONTROL: Kullanıcı giriş yapmamışsa yüklemeyi hemen durdur
    if (user == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    // 2. FİREBASE BAĞLANTISI
    _db
        .collection('users')
        .doc(user.uid)
        .collection('sos_points')
        .snapshots()
        .listen((snapshot) async {
      
      // Eğer veritabanı tamamen boşsa varsayılan Beyoğlu noktalarını ekle
      if (snapshot.docs.isEmpty) {
        await _addDefaultBeyogluPoints();
        // Ekleme bitince yükleniyor animasyonunu kapat!
        _isLoading = false;
        notifyListeners();
        return;
      }

      _points.clear();
      for (var doc in snapshot.docs) {
        var data = doc.data();
        _points.add(
          SupportPoint(
            name: data['name'] ?? 'İsimsiz',
            type: data['type'] ?? 'Destek',
            phoneNumber: data['phoneNumber'] ?? '',
            address: data['address'] ?? 'Adres belirtilmemiş',
            latitude: (data['latitude'] ?? 41.018).toDouble(),
            longitude: (data['longitude'] ?? 28.922).toDouble(),
          ),
        );
      }
      
      // Veriler başarıyla çekildiyse yükleniyor animasyonunu kapat
      _isLoading = false;
      notifyListeners(); 
      
    }, onError: (error) {
      // 3. KONTROL: Eğer Firebase izin hatası (Permission Denied) verirse sonsuza kadar dönmesin
      debugPrint("Firebase çekme hatası: $error");
      _isLoading = false;
      notifyListeners();
    });
  }

  // Varsayılan noktaları ekleyen yardımcı fonksiyon
  Future<void> _addDefaultBeyogluPoints() async {
    await addCustomSupportPoint(SupportPoint(
      name: "Beyoğlu İlçe Emniyet Müdürlüğü",
      type: "Polis",
      phoneNumber: "0212 243 51 90",
      address: "Kuloğlu, Beyoğlu, İstanbul",
      latitude: 41.0335,
      longitude: 28.9778,
    ));
    await addCustomSupportPoint(SupportPoint(
      name: "Beyoğlu Psikolojik Danışmanlık",
      type: "Klinik",
      phoneNumber: "0212 251 00 00",
      address: "Gümüşsuyu, Beyoğlu, İstanbul",
      latitude: 41.0370,
      longitude: 28.9850,
    ));
  }

  // --- FİREBASE'E YENİ KİŞİ/NOKTA EKLE ---
  Future<void> addCustomSupportPoint(SupportPoint newPoint) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _db
          .collection('users')
          .doc(user.uid)
          .collection('sos_points')
          .add({
        'name': newPoint.name,
        'type': newPoint.type,
        'phoneNumber': newPoint.phoneNumber,
        'address': newPoint.address,
        // YENİ: Yeni noktanın koordinatlarını Firebase'e yazıyoruz
        'latitude': newPoint.latitude,
        'longitude': newPoint.longitude,
        'createdAt': FieldValue.serverTimestamp(), 
      });
    }
  }
}