import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import 'widgets/quote_card.dart';
import 'widgets/emotion_tracking_card.dart';
import 'widgets/draggable_chatbot_fab.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/breathing_exercise_card.dart';
import 'widgets/community_latest_card.dart';
import '../../diary/view/diary_view.dart';
import '../../meditation/view/meditation_view.dart';
// Profil, SOS ve Harita sayfaları eklendi
import '../../profile/view/profile_view.dart';
import '../../sos/view/sos_view.dart'; 
import '../../sos/view/all_points_map_view.dart';
import '../../community/view/community_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 2; // Ana sayfa varsayılan olarak seçili
  String _currentQuote = AppConstants.dailyQuotes.first;

  @override
  void initState() {
    super.initState();
    _setDailyQuote();
  }

  Future<void> _setDailyQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final quotes = AppConstants.dailyQuotes;
    
    final todayStr = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    final lastQuoteDate = prefs.getString('last_quote_date');
    
    List<String>? shuffledIndices = prefs.getStringList('shuffled_quote_indices');
    int currentIndex = prefs.getInt('quote_current_index') ?? 0;

    // Eğer henüz karıştırılmış liste yoksa veya liste eksik/hatalıysa
    if (shuffledIndices == null || shuffledIndices.isEmpty || shuffledIndices.length != quotes.length) {
      final list = List<int>.generate(quotes.length, (i) => i);
      list.shuffle(Random());
      shuffledIndices = list.map((e) => e.toString()).toList();
      currentIndex = 0;
      await prefs.setStringList('shuffled_quote_indices', shuffledIndices);
      await prefs.setInt('quote_current_index', currentIndex);
    }

    // Eğer bugün yeni bir günse, sıradaki söze geç
    if (lastQuoteDate != todayStr) {
      if (lastQuoteDate != null) {
        currentIndex++;
      }
      
      // Liste bittiyse yeniden karıştır ve başa dön
      if (currentIndex >= shuffledIndices.length) {
        final list = List<int>.generate(quotes.length, (i) => i);
        list.shuffle(Random());
        shuffledIndices = list.map((e) => e.toString()).toList();
        currentIndex = 0;
        await prefs.setStringList('shuffled_quote_indices', shuffledIndices);
      }
      
      await prefs.setInt('quote_current_index', currentIndex);
      await prefs.setString('last_quote_date', todayStr);
    }

    // Seçili sözü al
    int quoteIndex = int.parse(shuffledIndices[currentIndex]);
    
    setState(() {
      _currentQuote = quotes[quoteIndex];
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0: // Günlük
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DiaryView()), 
        ).then((_) {
          setState(() {
            _currentIndex = 2; 
          });
        });
        break;
      case 1: // Topluluk
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CommunityView()),
        ).then((_) {
          setState(() {
            _currentIndex = 2; 
          });
        });
        break;
      case 2: // Ana Sayfa - Zaten buradayız
        break;
      case 3: // Meditasyon
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MeditationView()),
        ).then((_) {
          setState(() {
            _currentIndex = 2;
          });
        });
        break;
      case 4: // Harita Butonu
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AllPointsMapView()),
        ).then((_) {
          setState(() {
            _currentIndex = 2; 
          });
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ana Sayfa',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        // --- TAM ORTALANMIŞ VE İÇİ BEYAZ PROFİL İKONU ---
        leadingWidth: 72, 
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileView()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                // Arka planı temanın ana (koyu) rengi yaptık
                color: Theme.of(context).colorScheme.primary, 
                shape: BoxShape.circle,
              ),
              // İkonu da bembeyaz yaptık!
              child: const Icon(
                Icons.person, 
                color: Colors.white, 
                size: 28,
              ),
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 100,
              height: 60,
              child: ElevatedButton(
                // --- SOS BUTONU YÖNLENDİRMESİ ---
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SosView()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'SOS',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuoteCard(quote: _currentQuote),
                const SizedBox(height: 32),
                const Row( 
                  children: [
                    Expanded(flex: 1, child: EmotionTrackingCard()),
                    SizedBox(width: 12),
                    Expanded(flex: 1, child: BreathingExerciseCard()),
                  ],
                ),
                const SizedBox(height: 12),
                const CommunityLatestCard(),
                const SizedBox(height: 24),
                // TODO: Daha fazla ana sayfa içeriği eklenecek
              ],
            ),
          ),
          const DraggableChatbotFab(),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}