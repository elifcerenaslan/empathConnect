import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:url_launcher/url_launcher.dart';
import 'package:empath_connect/models/support_point.dart';
import 'package:empath_connect/widgets/support_point_card.dart';
import 'package:empath_connect/core/providers/sos_provider.dart';
// YENİ: Harita picker sayfasını ekledik
import 'map_picker_view.dart'; 

class SosView extends StatefulWidget {
  const SosView({super.key});

  @override
  State<SosView> createState() => _SosViewState();
}

class _SosViewState extends State<SosView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  // YENİ: Adres alanı için de bir kontrolcü ekledik
  final TextEditingController _addressController = TextEditingController();

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

  Future<void> _openMap(String address) async {
    final String encodedAddress = Uri.encodeComponent(address); 
    final Uri googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$encodedAddress");
    try {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Harita açılamadı: $address")),
        );
      }
    }
  }

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

  // --- YENİ: HARİTA SAYFASINI AÇAN VE ADRESİ GETİREN FONKSİYON ---
  Future<void> _pickLocationFromMap() async {
    // Harita sayfasını aç ve oradan dönecek sonucu (adresi) bekle
    final String? selectedAddress = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerView()),
    );

    // Eğer bir adres seçilip geri dönüldüyse, formdaki alanı güncelle
    if (selectedAddress != null && mounted) {
      setState(() {
        _addressController.text = selectedAddress;
      });
    }
  }

  void _showAddPointDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Güvenilir Kişi Ekle"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "İsim (Örn: Annem)"),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Telefon Numarası"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              // YENİ: Adres girişi ve Haritadan Seç butonu
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: "Adres",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.location_on, color: Colors.red),
                    onPressed: _pickLocationFromMap, // Haritayı açar
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
                final newPoint = SupportPoint(
                  name: _nameController.text,
                  type: "Özel",
                  phoneNumber: _phoneController.text,
                  address: _addressController.text.isEmpty ? "Adres Belirtilmedi" : _addressController.text,
                );
                context.read<SosProvider>().addCustomSupportPoint(newPoint);
                _nameController.clear();
                _phoneController.clear();
                _addressController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Ekle"),
          ),
        ],
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
                onMapTap: () => _openMap(point.address),
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