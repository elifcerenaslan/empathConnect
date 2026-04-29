import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapPickerView extends StatefulWidget {
  const MapPickerView({super.key});

  @override
  State<MapPickerView> createState() => _MapPickerViewState();
}

class _MapPickerViewState extends State<MapPickerView> {
  LatLng _selectedLocation = const LatLng(41.018, 28.922); // Başlangıç: İstanbul
  String _currentAddress = "Konum seçmek için haritaya dokunun";

  // Koordinatı adrese çevirme (Reverse Geocoding)
  Future<void> _getAddress(LatLng location) async {
    final url = Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=${location.latitude}&lon=${location.longitude}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _currentAddress = data['display_name'] ?? "Bilinmeyen Adres";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Konum Seç")),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 13.0,
              onTap: (tapPosition, point) {
                setState(() {
                  _selectedLocation = point;
                });
                _getAddress(point);
              },
            ),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedLocation,
                    child: const Icon(Icons.location_on, color: Colors.red, size: 45),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20, left: 20, right: 20,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_currentAddress, textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, {
                        'address': _currentAddress,
                        'lat': _selectedLocation.latitude,
                        'lon': _selectedLocation.longitude,
                      }),
                      child: const Text("Bu Konumu Seç"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}