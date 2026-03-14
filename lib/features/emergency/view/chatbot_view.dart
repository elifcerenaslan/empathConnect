import 'package:flutter/material.dart';

class ChatbotView extends StatefulWidget {
const ChatbotView({super.key});

@override
State<ChatbotView> createState() => _ChatbotViewState();
}

class _ChatbotViewState extends State<ChatbotView> {
final List<Map<String, dynamic>> messages = [
{'text': 'Merhaba, senin için buradayım. Bugün kendini nasıl hissediyorsun?', 'isMe': false, 'time': '10:23'},
{'text': 'Şu an biraz bunalmış hissediyorum.', 'isMe': true, 'time': '10:24'},
{'text': 'Anlıyorum. Böyle hissetmen çok doğal. Seni dinliyorum...', 'isMe': false, 'time': '10:24'},
];

@override
Widget build(BuildContext context) {
bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

return Scaffold(
  // Koyu modda Figma'daki o derin lacivert, açık modda tertemiz beyaz
  backgroundColor: isDarkMode ? const Color(0xFF121421) : Colors.white,
  
  appBar: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios, color: isDarkMode ? Colors.white70 : Colors.grey),
      onPressed: () {},
    ),
    title: Row(
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFFD5F0E6),
          child: Icon(Icons.person, color: Colors.teal, size: 20),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mia', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontSize: 16)),
            const Text('Destek Arkadaşı', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ],
    ),
  ),
  
  body: Column(
    children: [
      // MESAJLARIN LİSTELENDİĞİ ALAN
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            final isMe = msg['isMe'];

            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isMe 
                        ? (isDarkMode ? const Color(0xFF3B3B5E) : const Color(0xFFFFB3FA))
                        : (isDarkMode ? const Color(0xFF1C1C2D) : const Color(0xFFD5F0E6)),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isMe ? 20 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 20),
                      ),
                    ),
                    child: Text(
                      msg['text'],
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                    ),
                  ),
                  Text(msg['time'], style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        ),
      ),

      // İŞTE UNUTTUĞUM O MESAJ YAZMA ALANI (ALT KISIM)
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1C1C2D) : Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.add_circle_outline, color: isDarkMode ? Colors.white54 : Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF121421) : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Bir mesaj yazın...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: const Color(0xFFFFB3FA),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);
}
}