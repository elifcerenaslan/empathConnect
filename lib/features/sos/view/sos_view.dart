import 'package:empath_connect/models/support_point.dart';
import 'package:empath_connect/widgets/support_point_card.dart';
import 'package:flutter/material.dart';

class SosView extends StatelessWidget {
  const SosView({super.key});

  @override
  Widget build(BuildContext context) {
    // Örnek veri listesi (İleride bunlar veritabanından gelecek)
    final List<SupportPoint> supportPoints = [
      SupportPoint(
        name: "İstanbul Sağlık ve Teknoloji Hastanesi",
        type: "Hastane",
        phoneNumber: "0212XXXXXXX",
        address: "Zeytinburnu, İstanbul",
      ),
      SupportPoint(
        name: "Merkez Şehit Polis Merkezi",
        type: "Polis",
        phoneNumber: "155",
        address: "Beşiktaş, İstanbul",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yakındaki Destek Noktaları'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: supportPoints.length,
        itemBuilder: (context, index) {
          return SupportPointCard(
            point: supportPoints[index],
            onMapTap: () {
              // Google Maps açma mantığı buraya gelecek
              print("${supportPoints[index].name} için harita açılıyor...");
            },
            onCallTap: () {
              // Arama yapma mantığı buraya gelecek
              print("${supportPoints[index].phoneNumber} aranıyor...");
            },
          );
        },
      ),
    );
  }
}