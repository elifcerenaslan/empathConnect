import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as genai;

import '../data/chat_message.dart';

class GeminiService {
  GeminiService._();

  static String? _cachedApiKey;

  static Future<genai.GenerativeModel> _getModel() async {
    if (_cachedApiKey == null) {
      final doc = await FirebaseFirestore.instance
          .collection('config')
          .doc('api_keys')
          .get();
          
      _cachedApiKey = doc.data()?['gemini_key'] as String?;
      
      if (_cachedApiKey == null || _cachedApiKey!.isEmpty) {
        throw Exception('API Anahtarı Firebase\'de bulunamadı.');
      }
    }

    return genai.GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _cachedApiKey!,
      systemInstruction: genai.Content.system(
        'Senin adın Mia. Empati kurabilen, yargılamayan, şefkatli ve destekleyici bir sanal yol arkadaşısın. '
        'Kullanıcılar sana içlerini dökecekler. Onları dikkatle dinle ve duygularını anladığını hissettir. '
        'Sadece durum gerçekten ciddi göründüğünde veya kullanıcı panik/kaygı içindeyse nefes egzersizi veya sakinleşme teknikleri öner. Her mesajda sürekli meditasyon tavsiyesi VERME. '
        'Gerçek bir insan gibi, bir mesajlaşma uygulamasında arkadaşınla nasıl konuşuyorsan öyle konuş. Cevapların genelde doğal, sıcak ve net olsun. Konunun gidişatına göre bazen çok kısa, bazen biraz daha uzun cevaplar verebilirsin ancak ASLA uzun paragraflar, destanlar veya madde imli listeler yazma.',
      ),
    );
  }

  static Future<String> sendMessage(
    String text,
    List<ChatMessage> history,
  ) async {
    try {
      var pastHistory = history.take(history.length - 1).toList();

      while (pastHistory.isNotEmpty && !pastHistory.first.isUser) {
        pastHistory.removeAt(0);
      }

      final chatHistory = pastHistory.map((msg) {
        return genai.Content(msg.isUser ? 'user' : 'model', [
          genai.TextPart(msg.text),
        ]);
      }).toList();

      final model = await _getModel();
      final chat = model.startChat(history: chatHistory);

      // 45 Saniyelik TimeOut (Soğuk başlangıç veya ağ gecikmeleri için uzatıldı)
      final response = await chat
          .sendMessage(genai.Content.text(text))
          .timeout(
            const Duration(seconds: 45),
            onTimeout: () =>
                throw TimeoutException('Bağlantı zaman aşımına uğradı.'),
          );

      return response.text ?? 'Seni tam olarak anlayamadım, tekrar eder misin?';
    } on TimeoutException {
      return 'Bağlantı kurmakta zorlanıyorum. İnternetini kontrol edip tekrar dener misin?';
    } catch (e) {
      print('Gemini hatası: $e');
      return 'Şu an bir teknik aksaklık yaşıyorum, lütfen birazdan tekrar dene.';
    }
  }
}
