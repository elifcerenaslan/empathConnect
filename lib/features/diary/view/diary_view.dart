import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/diary_entry.dart';
import '../services/diary_service.dart';
import 'widgets/emotion_selector.dart';
import 'widgets/mood_slider.dart';
import 'widgets/diary_entry_field.dart';
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
  File? _selectedImage;
  String? _existingImageUrl;
  String _existingContent = '';
  bool _isUploading = false;
  bool _isLoadingTodayEntry = true;
  final DiaryService _diaryService = DiaryService();
  final ImagePicker _picker = ImagePicker();

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
            // Metin kutusuna eski yazıyı DOLDURMUYORUZ. Boş başlıyor.
            _existingImageUrl = entry.imageUrl;
            _existingContent = entry.content; // Eski yazıyı hafızada tutuyoruz
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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
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
      // ID olarak bugünün tarihini (YYYY-MM-DD) kullanıyoruz
      // Böylece her gün için sadece TEK bir kayıt olur, aynı gün tekrar kaydedilirse üzerine yazılır (overwrite)
      final entryId = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      String? imageUrl = _existingImageUrl;

      if (_selectedImage != null) {
        imageUrl = await _diaryService.uploadImage(_selectedImage!, entryId);
      }

      // Hafızadaki eski metnin sonuna ekliyoruz (Ağ isteği yapmadan!)
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
        imageUrl: imageUrl,
      );

      _diaryService.addEntry(newEntry);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Günlük güncellendi!')),
      );

      // SADECE metin kutusunu temizle ve fotoğraf seçimini kaldır.
      // Seçili YÜZ MODU ve PUAN aynen kalsın!
      setState(() {
        _selectedImage = null;
        _existingContent = finalContent; // Bir sonraki ekleme için güncel metni hafızada tut
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
      _selectedImage = null;
      _existingImageUrl = null;
      _existingContent = ''; // Temizlenince hafızayı da sıfırla
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
            const SizedBox(height: 24),
            Text('Fotoğraf Ekle (Opsiyonel)', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickImage,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(12),
                  image: _selectedImage != null
                      ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : _existingImageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(_existingImageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                ),
                child: (_selectedImage == null && _existingImageUrl == null)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 40, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(height: 8),
                          Text('Galeriden Seç', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                        ],
                      )
                    : null,
              ),
            ),
            if (_selectedImage != null || _existingImageUrl != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedImage = null;
                      _existingImageUrl = null;
                    });
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Fotoğrafı Kaldır', style: TextStyle(color: Colors.red)),
                ),
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
            // Burada artık Firestore'dan gelenleri dinleyen yeni bir DiaryEntriesList çağıracağız.
            const DiaryEntriesList(),
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
