import 'package:flutter/material.dart';

class MeditationView extends StatefulWidget {
const MeditationView({super.key});

@override
State<MeditationView> createState() => _MeditationViewState();
}

class _MeditationViewState extends State<MeditationView> {
// Varsayılan olarak seçili gelen ses
String selectedSound = 'Yağmur';

// Seçebileceğimiz sesler ve ikonları (Dummy Data)
final List<Map<String, dynamic>> sounds = [
{'name': 'Yağmur', 'icon': Icons.water_drop},
{'name': 'Orman', 'icon': Icons.park},
{'name': 'Okyanus', 'icon': Icons.waves},
{'name': 'Ateş', 'icon': Icons.local_fire_department},
{'name': 'Rüzgar', 'icon': Icons.air},
];

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Nefes & Meditasyon', style: TextStyle(fontWeight: FontWeight.bold)),
actions: [
IconButton(
icon: const Icon(Icons.close),
onPressed: () {},
),
],
),
// Ekrana sığmazsa diye kaydırma özelliği ekledik
body: SingleChildScrollView(
child: Padding(
padding: const EdgeInsets.all(24.0),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Text(
'Sakinleşmek için ritmi izle ve bir ses seç.',
style: TextStyle(fontSize: 16, color: Colors.grey),
textAlign: TextAlign.center,
),

          const SizedBox(height: 40),
          
          // MERKEZDEKİ BÜYÜK NEFES ÇEMBERİ
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
                width: 4,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.air, 
                size: 80,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // SAYAÇ
          const Text(
            '04 : 12',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dakika                 Saniye', 
            style: TextStyle(color: Colors.grey, letterSpacing: 1.5),
          ),
          
          const SizedBox(height: 40),

          // SES SEÇENEKLERİ BAŞLIĞI
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Rahatlatıcı Sesler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          
          const SizedBox(height: 15),

          // YATAY KAYDIRILABİLİR SES KARTLARI LİSTESİ
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sounds.length,
              itemBuilder: (context, index) {
                final sound = sounds[index];
                final isSelected = selectedSound == sound['name'];

                return GestureDetector(
                  onTap: () {
                    // Karta tıklandığında seçili sesi günceller ve ekranı yeniler
                    setState(() {
                      selectedSound = sound['name'];
                    });
                  },
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Theme.of(context).colorScheme.primary // Seçiliyse ana tema rengi
                          : Theme.of(context).colorScheme.surface, // Değilse arka plan rengi
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected 
                            ? Theme.of(context).colorScheme.primary 
                            : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          sound['icon'],
                          color: isSelected ? Colors.white : Colors.grey,
                          size: 30,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          sound['name'],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 40),
          
          // OTURUMU BİTİR BUTONU
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 2,
              ),
              onPressed: () {},
              child: const Text(
                'Oturumu Bitir', 
                style: TextStyle(fontSize: 18, color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  ),
);
}
}