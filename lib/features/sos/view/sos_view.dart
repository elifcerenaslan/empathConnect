import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:url_launcher/url_launcher.dart';
import 'package:empath_connect/models/support_point.dart';
import 'package:empath_connect/widgets/support_point_card.dart';
import 'package:empath_connect/core/providers/sos_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'map_picker_view.dart'; 

class SosView extends StatefulWidget {
  const SosView({super.key});

  @override
  State<SosView> createState() => _SosViewState();
}

class _SosViewState extends State<SosView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  bool _isSaving = false; 
  double? _tempLat;
  double? _tempLon;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SosProvider>().fetchSupportPoints();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // --- ADRESİ KOORDİNATA ÇEVİREN FONKSİYON ---
  Future<Map<String, double>> _getCoordinatesFromAddress(String address) async {
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=1');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          return {
            'latitude': double.parse(data[0]['lat']),
            'longitude': double.parse(data[0]['lon']),
          };
        }
      }
    } catch (e) {
      debugPrint("Adres bulunamadı: $e");
    }
    return {'latitude': 41.018, 'longitude': 28.922}; // Varsayılan İstanbul
  }

  // --- GOOGLE MAPS YOL TARİFİ AÇAN FONKSİYON ---
  Future<void> _openMap(double lat, double lon) async {
    final Uri googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lon");
    try {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Harita uygulaması açılamadı.")),
        );
      }
    }
  }

  // --- TELEFON ARAMASI YAPAN FONKSİYON ---
  Future<void> _makePhoneCall(String phoneNumber) async {
    final String cleanNumber = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    final Uri telUrl = Uri.parse("tel:$cleanNumber");
    try {
      await launchUrl(telUrl);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bu cihazda arama yapılamıyor.")),
        );
      }
    }
  }

  // --- HARİTADAN İĞNE İLE KONUM SEÇME FONKSİYONU ---
  Future<void> _pickLocationFromMap() async {
    final Map<String, dynamic>? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerView()),
    );

    if (result != null && mounted) {
      setState(() {
        _addressController.text = result['address'];
        _tempLat = result['lat'];
        _tempLon = result['lon'];
      });
    }
  }

  void _showAddPointDialog() {
    showDialog(
      context: context,
      barrierDismissible: !_isSaving, 
      builder: (context) => StatefulBuilder( 
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Güvenilir Kişi Ekle"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "İsim (Örn: Annem)"),
                    enabled: !_isSaving,
                  ),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: "Telefon Numarası"),
                    keyboardType: TextInputType.phone,
                    enabled: !_isSaving,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _addressController,
                    enabled: !_isSaving,
                    decoration: InputDecoration(
                      labelText: "Adres",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.location_on, color: Colors.red),
                        onPressed: _isSaving ? null : _pickLocationFromMap, 
                      ),
                    ),
                    onChanged: (val) {
                      // Eğer kullanıcı haritadan seçtikten sonra adresi eliyle değiştirirse koordinatları sıfırla
                      _tempLat = null;
                      _tempLon = null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: _isSaving ? null : () {
                  _tempLat = null;
                  _tempLon = null;
                  Navigator.pop(context);
                },
                child: const Text("İptal"),
              ),
              ElevatedButton(
                onPressed: _isSaving ? null : () async {
                  if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
                    
                    setStateDialog(() => _isSaving = true);
                    
                    final String addressText = _addressController.text.isEmpty ? "İstanbul" : _addressController.text;
                    double finalLat;
                    double finalLon;

                    // Eğer haritadan seçildiyse hazırdaki koordinatı kullan, yoksa internetten çevir
                    if (_tempLat != null && _tempLon != null) {
                      finalLat = _tempLat!;
                      finalLon = _tempLon!;
                    } else {
                      final coords = await _getCoordinatesFromAddress(addressText);
                      finalLat = coords['latitude']!;
                      finalLon = coords['longitude']!;
                    }

                    final newPoint = SupportPoint(
                      name: _nameController.text,
                      type: "Özel",
                      phoneNumber: _phoneController.text,
                      address: addressText,
                      latitude: finalLat,
                      longitude: finalLon,
                    );
                    
                    if (context.mounted) {
                      await context.read<SosProvider>().addCustomSupportPoint(newPoint);
                      
                      _nameController.clear();
                      _phoneController.clear();
                      _addressController.clear();
                      _tempLat = null;
                      _tempLon = null;
                      
                      setStateDialog(() => _isSaving = false);
                      Navigator.pop(context); 
                    }
                  }
                },
                child: _isSaving 
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                    : const Text("Ekle"),
              ),
            ],
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yakındaki Destek Noktaları')),
      body: Consumer<SosProvider>(
        builder: (context, sosProvider, child) {
          if (sosProvider.isLoading) return const Center(child: CircularProgressIndicator());
          if (sosProvider.points.isEmpty) return const Center(child: Text("Nokta bulunamadı."));
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sosProvider.points.length,
            itemBuilder: (context, index) {
              final point = sosProvider.points[index];
              return SupportPointCard(
                point: point,
                // BURASI DÜZELTİLDİ: Artık adres yerine enlem ve boylam gönderiyoruz
                onMapTap: () => _openMap(point.latitude, point.longitude),
                onCallTap: () => _makePhoneCall(point.phoneNumber),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPointDialog,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}