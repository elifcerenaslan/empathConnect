import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:empath_connect/core/providers/sos_provider.dart';

class AllPointsMapView extends StatelessWidget {
  const AllPointsMapView({super.key});

  @override
  Widget build(BuildContext context) {
    // SOS noktalarını (Hastane, Polis, Annem vb.) provider'dan izliyoruz
    final sosProvider = context.watch<SosProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Güvenli Noktalar Haritası"),
      ),
      body: Stack(
        children: [
          // Harita simülasyonu zemini
          Container(
            color: Colors.grey[200],
            child: const Center(
              child: Icon(Icons.map_outlined, size: 150, color: Colors.grey),
            ),
          ),
          
          // Listedeki her nokta için bir iğne (Marker) oluşturuyoruz
          ...sosProvider.points.asMap().entries.map((entry) {
            int idx = entry.key;
            var point = entry.value;
            
            return Positioned(
              // Noktaları ekrana farklı yerlere dağıtıyoruz
              top: 120.0 + (idx * 100), 
              left: 70.0 + (idx * 40),
              child: Column(
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 45),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
                    ),
                    child: Text(
                      point.name, 
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}