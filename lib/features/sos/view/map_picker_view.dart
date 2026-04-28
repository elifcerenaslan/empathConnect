import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapPickerView extends StatefulWidget {
  const MapPickerView({super.key});

  @override
  State<MapPickerView> createState() => _MapPickerViewState();
}

class _MapPickerViewState extends State<MapPickerView> {
  LatLng? _pickedLocation;
  String _pickedAddress = "Haritadan bir nokta seçin";

  // Başlangıç konumu (İstanbul'un merkezi olarak ayarlandı)
  final LatLng _initialCenter = const LatLng(41.0082, 28.9784);

  // Haritaya tıklandığında çalışacak fonksiyon
  void _selectLocation(LatLng position) async {
    setState(() {
      _pickedLocation = position;
      _pickedAddress = "Adres çözümleniyor...";
    });

    try {
      // Tıklanan koordinatın gerçek hayattaki adresini bul
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          // Bulunan sokağı ve ilçeyi yazdır
          _pickedAddress = "${place.street}, ${place.subLocality}, ${place.administrativeArea}";
        });
      }
    } catch (e) {
      setState(() {
        _pickedAddress = "Koordinat: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konum Seç'),
        actions: [
          // Eğer bir nokta seçildiyse SAĞ ÜSTTE ONAY BUTONU çıkar
          if (_pickedLocation != null)
            IconButton(
              icon: const Icon(Icons.check, size: 30),
              onPressed: () {
                // Seçilen adresi alıp bir önceki sayfaya (SosView'a) geri gönder
                Navigator.pop(context, _pickedAddress);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            // --- GOOGLE HARİTALAR VİTGENİ ---
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialCenter,
                zoom: 13,
              ),
              onTap: _selectLocation, // Tıklayınca fonksiyonu çalıştır
              // Eğer seçili nokta varsa oraya kırmızı bir iğne (Marker) batır
              markers: _pickedLocation == null
                  ? {}
                  : {
                      Marker(
                        markerId: const MarkerId('secilen_nokta'),
                        position: _pickedLocation!,
                      ),
                    },
            ),
          ),
          // --- ALT TARAFTAKİ BİLGİ ÇUBUĞU ---
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Text(
              _pickedAddress,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}