import 'package:flutter/material.dart';

class ChatbotView extends StatefulWidget {
const ChatbotView({super.key});

@override
State<ChatbotView> createState() => _ChatbotViewState();
}

class _ChatbotViewState extends State<ChatbotView> {
// İŞTE SAHTE (DUMMY) MESAJ LİSTEMİZ (Sanki önceden konuşulmuş gibi)
final List<Map<String, dynamic>> messages = [
{
'text': 'Merhaba, ben buradayım. Bugün kendini nasıl hissediyorsun?',
'isMe': false, // Asistanın mesajı (Sola yaslı ve gri olacak)
},
{
'text': 'Şu an biraz bunalmış hissediyorum.',
'isMe': true, // Senin mesajın (Sağa yaslı ve lila/pembe olacak)
},
{
'text': 'Anlıyorum. Böyle hissetmen çok normal. Seni dinliyorum. Bu durum hakkında konuşmak ister misin, yoksa bir rahatlama egzersizi mi deneyelim?',
'isMe': false,
},
];

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Destek Asistanı'),
),
body: Column(
children: [
// 1. KISIM: MESAJLARIN LİSTELENDİĞİ ALAN
Expanded(
child: ListView.builder(
padding: const EdgeInsets.all(16.0),
itemCount: messages.length,
itemBuilder: (context, index) {
final msg = messages[index];
final isMe = msg['isMe']; // Mesaj benim mi yoksa asistanın mı?

            return Align(
              // Benim mesajımsa sağa, asistanınsa sola yasla
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                // Baloncuğun şekli ve rengi
                decoration: BoxDecoration(
                  color: isMe 
                      ? Theme.of(context).colorScheme.primary // Benim mesajım lila/pembe
                      : Theme.of(context).colorScheme.surface, // Asistan gri/lacivert
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isMe ? 20 : 0), // Asistanın kuyruğu solda
                    bottomRight: Radius.circular(isMe ? 0 : 20), // Benim kuyruğum sağda
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    )
                  ]
                ),
                // Balonun içindeki yazı
                child: Text(
                  msg['text'],
                  style: TextStyle(
                    color: isMe ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      
      // 2. KISIM: MESAJ YAZMA KUTUSU (En altta)
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Bir mesaj yazın...',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 24,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  // Şu an sahte verideyiz, butona basınca bir şey olmayacak
                },
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