import 'package:flutter/material.dart';
import '../../../core/services/community_service.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final _captionController = TextEditingController();
  final _imageUrlController = TextEditingController(); // Şimdilik basit URL girişi, ileride ImagePicker eklenecek
  final CommunityService _communityService = CommunityService();
  bool _isLoading = false;

  void _sharePost() async {
    if (_captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir açıklama yazın.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _communityService.createPost(
        _captionController.text,
        _imageUrlController.text.isNotEmpty 
            ? _imageUrlController.text 
            : 'https://via.placeholder.com/400', // Varsayılan görsel
      );
      
      if (!mounted) return;
      Navigator.pop(context); // Başarılıysa geri dön
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: \${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Gönderi'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _sharePost,
            child: _isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Paylaş', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _captionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Düşüncelerini paylaş...',
                border: InputBorder.none,
              ),
            ),
            const Divider(),
            const SizedBox(height: 16),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                hintText: 'Görsel URL\'si (Opsiyonel)',
                prefixIcon: Icon(Icons.link),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Not: İlerleyen aşamalarda buraya doğrudan galeriden fotoğraf seçme (ImagePicker) özelliği eklenecektir.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
