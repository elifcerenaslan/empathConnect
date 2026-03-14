import 'package:flutter/material.dart';

class MeditationView extends StatefulWidget {
  const MeditationView({super.key});

  @override
  State<MeditationView> createState() => _MeditationViewState();
}

class _MeditationViewState extends State<MeditationView> {
  String selectedFeeling = 'Mutlu';
  String selectedSound = 'Yağmur';

  final List<Map<String, dynamic>> feelings = [
    {'name': 'Stresli', 'icon': Icons.flash_on, 'color': const Color(0xFF9575CD)},
    {'name': 'Mutlu', 'icon': Icons.wb_sunny, 'color': const Color(0xFFFFB3FA)},
    {'name': 'Endişeli', 'icon': Icons.air, 'color': const Color(0xFF4DB6AC)},
    {'name': 'Üzgün', 'icon': Icons.cloud, 'color': const Color(0xFF64B5F6)},
  ];

  final List<Map<String, dynamic>> sounds = [
    {'name': 'Yağmur', 'icon': Icons.water_drop},
    {'name': 'Orman', 'icon': Icons.park},
    {'name': 'Okyanus', 'icon': Icons.waves},
    {'name': 'Ateş', 'icon': Icons.local_fire_department},
    {'name': 'Rüzgar', 'icon': Icons.wind_power},
  ];

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121421) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Nefes Alanı', 
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. DUYGU SEÇİMİ
            Text(
              'Bugün nasıl hissediyorsun?',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: feelings.length,
                itemBuilder: (context, index) {
                  final feeling = feelings[index];
                  bool isSelected = selectedFeeling == feeling['name'];
                  return GestureDetector(
                    onTap: () => setState(() => selectedFeeling = feeling['name']),
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? feeling['color'] : (isDarkMode ? const Color(0xFF1C1C2D) : const Color(0xFFF5F5F5)),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(feeling['icon'], color: isSelected ? Colors.white : Colors.grey, size: 28),
                          const SizedBox(height: 6),
                          Text(feeling['name'], style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),

            // 2. NEFES ÇEMBERİ
            Center(
              child: Column(
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDarkMode ? const Color(0xFF1C1C2D) : const Color(0xFFFFB3FA).withOpacity(0.1),
                      border: Border.all(color: const Color(0xFFFFB3FA), width: 2),
                    ),
                    child: const Icon(Icons.spa, size: 50, color: Color(0xFFFFB3FA)),
                  ),
                  const SizedBox(height: 20),
                  Text('04 : 12', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w300, color: isDarkMode ? Colors.white : Colors.black87)),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 3. RAHATLATICI SESLER (İstediğin o son kısım!)
            Text(
              'Rahatlatıcı Sesler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sounds.length,
                itemBuilder: (context, index) {
                  final sound = sounds[index];
                  bool isSelected = selectedSound == sound['name'];
                  return GestureDetector(
                    onTap: () => setState(() => selectedSound = sound['name']),
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? (isDarkMode ? const Color(0xFF4DB6AC) : const Color(0xFFD5F0E6))
                            : (isDarkMode ? const Color(0xFF1C1C2D) : const Color(0xFFF5F5F5)),
                        borderRadius: BorderRadius.circular(18),
                        border: isSelected ? Border.all(color: const Color(0xFF4DB6AC).withOpacity(0.5)) : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            sound['icon'], 
                            color: isSelected ? (isDarkMode ? Colors.white : const Color(0xFF00796B)) : Colors.grey,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            sound['name'], 
                            style: TextStyle(
                              color: isSelected ? (isDarkMode ? Colors.white : const Color(0xFF00796B)) : Colors.grey,
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}