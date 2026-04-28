import 'package:google_generative_ai/google_generative_ai.dart' as genai;

import '../data/chat_message.dart';

class GeminiService {
  GeminiService._();

  static const String _apiKey = 'AIzaSyDkq3BQhP1SzzAG9iFv5xtpKVVRGndGScY';
  
  static final _model = genai.GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: _apiKey,
    systemInstruction: genai.Content.system(
      'Senin adın Mia. Empati kurabilen, yargılamayan, sakin ve anlayışlı bir destek asistanısın. '
      'Kullanıcılar sana içlerini dökecekler. Onları dinle, duygularını anladığını hissettir, kısa ve öz cevaplar ver. '
      'Tıbbi veya psikiyatrik teşhis koyma. Sadece destekleyici ve şefkatli bir arkadaş gibi davran.',
    ),
  );

  static Future<String> sendMessage(String text, List<ChatMessage> history) async {
    try {
      // Geçmişten şu an gönderdiğimiz son mesajı (text) çıkarıyoruz
      var pastHistory = history.take(history.length - 1).toList();
      
      // Gemini API'si, geçmişin mutlaka bir 'user' (kullanıcı) mesajıyla başlamasını şart koşar.
      // Bizim listemiz Mia'nın "Hoş geldin" mesajıyla ('model') başladığı için, 
      // baştaki model mesajlarını temizleyerek sırayı user -> model -> user şeklinde düzenliyoruz.
      while (pastHistory.isNotEmpty && !pastHistory.first.isUser) {
        pastHistory.removeAt(0);
      }

      final chatHistory = pastHistory.map((msg) {
        return genai.Content(
          msg.isUser ? 'user' : 'model',
          [genai.TextPart(msg.text)],
        );
      }).toList();

      final chat = _model.startChat(history: chatHistory);
      final response = await chat.sendMessage(genai.Content.text(text));
      
      return response.text ?? 'Seni tam olarak anlayamadım, tekrar eder misin?';
    } catch (e) {
      print('Gemini hatası: $e');
      return 'Hata Detayı: $e';
    }
  }
}
