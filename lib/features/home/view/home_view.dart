import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import 'widgets/quote_card.dart';
import 'widgets/emotion_tracking_card.dart';
import 'widgets/chatbot_fab.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/breathing_exercise_card.dart';
import '../../diary/view/diary_view.dart';
import '../../meditation/view/meditation_view.dart';
import '../../profile/view/profile_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 2; // Home is selected by default
  String _currentQuote = AppConstants.dailyQuotes.first;

  @override
  void initState() {
    super.initState();
    _setDailyQuote();
  }

  void _setDailyQuote() {
    final quotes = AppConstants.dailyQuotes;
    final dailyQuote = quotes[(DateTime.now().day) % quotes.length];
    setState(() {
      _currentQuote = dailyQuote;
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0: // Diary
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DiaryView()),
        ).then((_) {
          setState(() {
            _currentIndex = 2; // Reset to Home when coming back
          });
        });
        break;
      case 1: // Community
        // TODO: Navigate to community
        break;
      case 2: // Home - already here
        break;
      case 3: // Meditation
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MeditationView()),
        ).then((_) {
          setState(() {
            _currentIndex = 2;
          });
        });
        break;
      case 4: // Map
        // TODO: Navigate to map
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
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.account_circle, size: 36, color: Colors.white),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileView()),
            );
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Container(
              width: 100,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  // No functionality for now
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuoteCard(quote: _currentQuote),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(flex: 1, child: EmotionTrackingCard()),
                const SizedBox(width: 12),
                Expanded(flex: 1, child: BreathingExerciseCard()),
              ],
            ),
            const SizedBox(height: 24),
            // TODO: Add more home content
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
      floatingActionButton: const ChatbotFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
