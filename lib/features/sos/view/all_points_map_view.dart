import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/providers/sos_provider.dart'; 

class AllPointsMapView extends StatelessWidget {
  const AllPointsMapView({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri telUrl = Uri.parse("tel:${phoneNumber.replaceAll(' ', '')}");
    if (await canLaunchUrl(telUrl)) {
      await launchUrl(telUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sosProvider = context.watch<SosProvider>();
    
    // Haritanın açılacağı merkez nokta (İstanbul)
    final LatLng mapCenter = const LatLng(41.018, 28.922);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Yakındaki Güvenli Noktalar"),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: mapCenter, 
          initialZoom: 13.0, // Başlangıç yakınlığı (Sokak seviyesi)
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.empath_connect', 
          ),
          
          MarkerLayer(
            markers: [
              // --- 1. SABİT MERKEZ NOKTASI (Her zaman görünür, senin konumun gibi düşün) ---
              Marker(
                point: mapCenter,
                width: 100,
                height: 80,
                child: Column(
                  children: [
                    const Icon(Icons.person_pin_circle, color: Colors.blue, size: 45),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue, width: 1),
                      ),
                      child: const Text("Sen", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

              // --- 2. DİNAMİK SOS NOKTALARI ---
              ...sosProvider.points.asMap().entries.map((entry) {
                int idx = entry.key;
                var point = entry.value;
                
                // Noktaları birbiri üstüne binmemesi için daire şeklinde dağıtıyoruz (Matematiksel offset)
                double offset = 0.008 + (idx * 0.002); // Merkezden uzaklık
                double angle = idx * 1.5; // Açısı
                
                final pointLocation = LatLng(
                  mapCenter.latitude + (offset * angle.cos()), 
                  mapCenter.longitude + (offset * angle.sin()),
                );

                return Marker(
                  point: pointLocation,
                  width: 120, // Genişliği biraz artırdık isimler sığsın diye
                  height: 80,
                  child: GestureDetector(
                    onTap: () => _makePhoneCall(point.phoneNumber),
                    child: Column(
                      children: [
                        const Icon(Icons.location_on, color: Colors.red, size: 40),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.black26)],
                          ),
                          child: Text(
                            point.name,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ],
      ),
      
      floatingActionButton: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                "${sosProvider.points.length} destek noktası bulundu.\nAramak için iğnelere dokunun.",
                style: TextStyle(color: Colors.grey[800], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}