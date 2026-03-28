import 'package:flutter/material.dart';

import '../data/chat_message.dart';
import '../services/chat_storage_service.dart';

class ChatbotView extends StatefulWidget {
  const ChatbotView({super.key});

  @override
  State<ChatbotView> createState() => _ChatbotViewState();
}

class _ChatbotViewState extends State<ChatbotView> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> _messages = [];
  ChatStorageService? _storage;
  int _localReplyIndex = 0;

  static const List<String> _localMiaReplies = [
    'Duygularını paylaştığın için teşekkür ederim. Şu an sohbet yalnızca bu cihazda saklanıyor; seni dinlediğimi bilmeni istiyorum.',
    'Anlattıkların önemli. Mesajın kaydedildi. Kendine nazik olmayı ve ihtiyaç duyduğunda güvendiğin biriyle konuşmayı ihmal etme.',
    'Buradayım; yazdıkların güvende. Zor bir gün mü geçiriyorsun? Nefes alıp yavaşlamak bazen yardımcı olur.',
    'Seni duyuyorum. Bu alan şimdilik yalnızca senin kayıtların için; ileride daha akıllı yanıtlar eklenebilir. Paylaştığın için teşekkürler.',
  ];

  bool _loadingHistory = true;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final storage = await ChatStorageService.create();
    final loaded = storage.loadMessages();
    if (!mounted) return;

    if (loaded.isEmpty) {
      final welcome = ChatMessage.welcome();
      setState(() {
        _storage = storage;
        _messages = [welcome];
        _loadingHistory = false;
      });
      await storage.saveMessages(_messages);
    } else {
      setState(() {
        _storage = storage;
        _messages = loaded;
        _loadingHistory = false;
      });
    }
    _scrollToBottom();
  }

  Future<void> _persist() async {
    final s = _storage;
    if (s == null) return;
    await s.saveMessages(_messages);
  }

  Future<void> _send() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _sending || _storage == null) return;

    final userMsg = ChatMessage(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      isUser: true,
      text: text,
      at: DateTime.now(),
    );

    setState(() {
      _messages = [..._messages, userMsg];
      _sending = true;
    });
    _textController.clear();
    await _persist();
    _scrollToBottom();

    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    final reply =
        _localMiaReplies[_localReplyIndex % _localMiaReplies.length];
    _localReplyIndex++;

    final botMsg = ChatMessage(
      id: 'a_${DateTime.now().millisecondsSinceEpoch}',
      isUser: false,
      text: reply,
      at: DateTime.now(),
    );
    setState(() {
      _messages = [..._messages, botMsg];
      _sending = false;
    });
    await _persist();
    _scrollToBottom();
  }

  Future<void> _resetChat() async {
    final s = _storage;
    if (s == null) return;
    await s.clear();
    final welcome = ChatMessage.welcome();
    setState(() => _messages = [welcome]);
    await s.saveMessages(_messages);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sohbet sıfırlandı.')),
      );
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF121421) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDarkMode ? Colors.white70 : Colors.grey,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFD5F0E6),
              child: Icon(Icons.person, color: Colors.teal, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mia',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    'Destek sohbeti',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
            onSelected: (v) {
              if (v == 'reset') _resetChat();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reset',
                child: Text('Sohbeti sıfırla'),
              ),
            ],
          ),
        ],
      ),
      body: _loadingHistory
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_sending ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_sending && index == _messages.length) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: isDarkMode
                                        ? Colors.white54
                                        : Colors.teal,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Mia yazıyor…',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white54
                                        : Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final msg = _messages[index];
                      final isMe = msg.isUser;

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? (isDarkMode
                                        ? const Color(0xFF3B3B5E)
                                        : const Color(0xFFFFB3FA))
                                    : (isDarkMode
                                        ? const Color(0xFF1C1C2D)
                                        : const Color(0xFFD5F0E6)),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(20),
                                  topRight: const Radius.circular(20),
                                  bottomLeft: Radius.circular(isMe ? 20 : 0),
                                  bottomRight: Radius.circular(isMe ? 0 : 20),
                                ),
                              ),
                              child: Text(
                                msg.text,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            Text(
                              msg.timeLabel,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF1C1C2D)
                        : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: isDarkMode ? Colors.white54 : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? const Color(0xFF121421)
                                  : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextField(
                              controller: _textController,
                              minLines: 1,
                              maxLines: 4,
                              enabled: !_sending,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _send(),
                              decoration: const InputDecoration(
                                hintText: 'Bir mesaj yazın…',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        CircleAvatar(
                          backgroundColor: const Color(0xFFFFB3FA),
                          child: IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _sending ? null : _send,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
