import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/diary_entry.dart';
import '../services/diary_service.dart';
import 'widgets/emotion_selector.dart';
import 'widgets/mood_slider.dart';
import 'widgets/diary_entry_field.dart';
import 'widgets/diary_entries_list.dart';

class DiaryView extends StatefulWidget {
  const DiaryView({super.key});

  @override
  State<DiaryView> createState() => _DiaryViewState();
}

class _DiaryViewState extends State<DiaryView> {
  String _selectedEmotion = AppConstants.emotionEmojis[2]; // Neutral by default
  double _moodLevel = 5.0;
  final TextEditingController _textController = TextEditingController();
  String _existingContent = '';
  bool _isUploading = false;
  bool _isLoadingTodayEntry = true;
  final DiaryService _diaryService = DiaryService();

  @override
  void initState() {
    super.initState();
    _loadTodayEntry();
  }

  Future<void> _loadTodayEntry() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final now = DateTime.now();
      final entryId = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('diaryEntries')
            .doc(entryId)
            .get();

        if (doc.exists && mounted) {
          final entry = DiaryEntry.fromMap(doc.data()!);
          setState(() {
            _selectedEmotion = entry.emotion;
            _moodLevel = entry.moodScore;
            _existingContent = entry.content;
          });
        }
      } catch (e) {
        debugPrint('Bugünün günlüğü çekilirken hata: $e');
      }
    }

    if (mounted) {
      setState(() {
        _isLoadingTodayEntry = false;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _saveDiaryEntry() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Günlük tutmak için giriş yapmalısınız.')),
      );
      return;
    }

    if (_selectedEmotion.isEmpty || _textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir duygu seçin ve not yazın')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final now = DateTime.now();
      final entryId = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      String finalContent = _textController.text.trim();
      if (_existingContent.isNotEmpty) {
        finalContent = "$_existingContent\n\n$finalContent";
      }

      final newEntry = DiaryEntry(
        id: entryId,
        userId: user.uid,
        emotion: _selectedEmotion,
        moodScore: _moodLevel,
        content: finalContent,
        createdAt: DateTime.now(),
        imageUrl: null,
      );

      _diaryService.addEntry(newEntry);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Günlük güncellendi!')),
      );

      setState(() {
        _existingContent = finalContent;
      });
      _textController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _clearForm() {
    setState(() {
      _selectedEmotion = AppConstants.emotionEmojis[2];
      _moodLevel = 5.0;
      _existingContent = '';
    });
    _textController.clear();
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
      body: _isLoadingTodayEntry
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isUploading ? null : _saveDiaryEntry,
                          child: _isUploading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text('Kaydet'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: _isUploading ? null : _clearForm,
                        child: const Text('Temizle'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const DiaryEntriesList(),
                ],
              ),
            ),
    );
  }
}
