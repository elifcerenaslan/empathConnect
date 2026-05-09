import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart' as genai;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../data/chat_message.dart';

class GeminiService {
  GeminiService._();

  static genai.GenerativeModel get _model {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('API Anahtarı bulunamadı.');
    }

    return genai.GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      systemInstruction: genai.Content.system(
        'Senin adın Mia. Empati kurabilen, yargılamayan, şefkatli ve destekleyici bir sanal yol arkadaşısın. '
        'Kullanıcılar sana içlerini dökecekler. Onların duygularını onayladıktan sonra nefes egzersizi veya odaklanma gibi küçük, rahatlatıcı bir adım öner. '
        'BUNU YAPARKEN ÇOK DİKKATLİ OL: Cevapların kısa ve öz olmalı. En fazla 2-3 cümle kullan. Destan yazma, uzun listeler verme. Gerçek bir insanın anlık mesajlaşmada yazdığı gibi kısa, sıcak ve net cevaplar ver.',
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

      final chat = _model.startChat(history: chatHistory);

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
