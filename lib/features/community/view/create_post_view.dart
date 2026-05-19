import 'package:flutter/material.dart';
import '../../../core/services/community_service.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final _captionController = TextEditingController();
  final CommunityService _communityService = CommunityService();
  bool _isLoading = false;

  void _sharePost() async {
    if (_captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir şeyler yazın.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _communityService.createPost(_captionController.text);
      
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
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Neler oluyor?',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
