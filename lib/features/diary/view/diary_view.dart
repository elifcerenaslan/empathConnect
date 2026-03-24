import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

import '../../../data/models/diary_entry.dart';

import 'widgets/emotion_selector.dart';

import 'widgets/mood_slider.dart';

import 'widgets/diary_entry_field.dart';

import 'widgets/drawing_canvas.dart';

import 'widgets/diary_entries_list.dart';

import '../../home/view/widgets/bottom_navigation.dart';

class DiaryView extends StatefulWidget {
  const DiaryView({super.key});

  @override
  State<DiaryView> createState() => _DiaryViewState();
}

class _DiaryViewState extends State<DiaryView> {
  String _selectedEmotion = AppConstants.emotionEmojis[2]; // Neutral by default

  double _moodLevel = 5.0;

  final TextEditingController _textController = TextEditingController();

  final GlobalKey<DrawingCanvasState> _drawingKey =
      GlobalKey<DrawingCanvasState>();

  final List<DiaryEntry> _savedEntries = [];

  @override
  void dispose() {
    _textController.dispose();

    super.dispose();
  }

  void _saveDiaryEntry() {
    if (_selectedEmotion.isEmpty || _textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir duygu seçin ve not yazın')),
      );

      return;
    }

    final newEntry = DiaryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),

      userId: 'current_user', // TODO: Get actual user ID

      emotion: _selectedEmotion,

      moodScore: _moodLevel,

      content: _textController.text.trim(),

      createdAt: DateTime.now(),
    );

    setState(() {
      _savedEntries.insert(0, newEntry); // Add to beginning of list
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Günlük kaydedildi!')));

    _clearForm();
  }

  void _clearForm() {
    setState(() {
      _selectedEmotion = AppConstants.emotionEmojis[2];

      _moodLevel = 5.0;
    });

    _textController.clear();

    _drawingKey.currentState?.clearCanvas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Günlük',

          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),

        backgroundColor: Theme.of(context).colorScheme.surface,

        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'Bugün Nasıl Hissediyorsun?',

              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 16),

            EmotionSelector(
              selectedEmotion: _selectedEmotion,

              onEmotionSelected: (emotion) {
                setState(() {
                  _selectedEmotion = emotion;
                });
              },
            ),

            const SizedBox(height: 24),

            Text('Ruh Hali', style: Theme.of(context).textTheme.headlineSmall),

            const SizedBox(height: 16),

            MoodSlider(
              value: _moodLevel,

              onChanged: (value) {
                setState(() {
                  _moodLevel = value;
                });
              },
            ),

            const SizedBox(height: 24),

            Text(
              'Günlük Notu',

              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 16),

            DiaryEntryField(
              controller: _textController,

              hintText: 'Bugün hakkında düşüncelerini yaz...',
            ),

            const SizedBox(height: 24),

            Text('Çizim', style: Theme.of(context).textTheme.headlineSmall),

            const SizedBox(height: 16),

            DrawingCanvas(key: _drawingKey),

            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveDiaryEntry,

                    child: const Text('Kaydet'),
                  ),
                ),

                const SizedBox(width: 16),

                OutlinedButton(
                  onPressed: _clearForm,

                  child: const Text('Temizle'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            DiaryEntriesList(entries: _savedEntries),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigation(
        currentIndex: 0,

        onTap: (index) {
          if (index != 0) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
