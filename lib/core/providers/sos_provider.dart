import 'package:flutter/material.dart';
import 'package:empath_connect/models/support_point.dart';

class SosProvider extends ChangeNotifier {
  List<SupportPoint> _points = [];
  bool _isLoading = false;

  List<SupportPoint> get points => _points;
  bool get isLoading => _isLoading;

  Future<void> fetchSupportPoints() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    _points = [
      SupportPoint(
        name: "İstanbul Sağlık ve Teknoloji Hastanesi",
        type: "Hastane",
        phoneNumber: "0212 414 30 00",
        address: "İSTÜN Hastanesi, Seyitnizam, Zeytinburnu, İstanbul",
      ),
      SupportPoint(
        name: "Merkez Şehit Polis Merkezi",
        type: "Polis",
        phoneNumber: "155",
        address: "Beşiktaş İlçe Emniyet Müdürlüğü, Beşiktaş, İstanbul",
      ),
      SupportPoint(
        name: "Kadın Destek Hattı (KADES)",
        type: "Destek",
        phoneNumber: "183",
        address: "Türkiye Geneli",
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  // YENİ EKLENEN KISIM: Kullanıcının yeni kişi eklemesini sağlayan fonksiyon
  void addCustomSupportPoint(SupportPoint newPoint) {
    _points.add(newPoint); // Yeni kişiyi listeye ekle
    notifyListeners(); // Arayüze haber ver: "Liste güncellendi, ekranı yenile!"
  }
}