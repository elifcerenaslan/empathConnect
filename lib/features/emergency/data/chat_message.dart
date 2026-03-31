class ChatMessage {
  ChatMessage({
    required this.id,
    required this.isUser,
    required this.text,
    required this.at,
  });

  final String id;
  final bool isUser;
  final String text;
  final DateTime at;

  String get timeLabel =>
      '${at.hour.toString().padLeft(2, '0')}:${at.minute.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'id': id,
        'isUser': isUser,
        'text': text,
        'at': at.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> j) {
    return ChatMessage(
      id: j['id'] as String,
      isUser: j['isUser'] as bool,
      text: j['text'] as String,
      at: DateTime.parse(j['at'] as String),
    );
  }

  static ChatMessage welcome() {
    return ChatMessage(
      id: 'welcome_${DateTime.now().millisecondsSinceEpoch}',
      isUser: false,
      text:
          'Merhaba, ben Mia. Burada seni duymak ve birlikte düşünebilmek için varım. Bugün kendini nasıl hissediyorsun, neler taşıyorsun?',
      at: DateTime.now(),
    );
  }
}
