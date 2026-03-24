class DiaryEntry {
  final String id;
  final String userId;
  final String emotion;
  final double moodScore;
  final String content;
  final DateTime createdAt;

  DiaryEntry({
    required this.id,
    required this.userId,
    required this.emotion,
    required this.moodScore,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'emotion': emotion,
      'moodScore': moodScore,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      userId: map['userId'],
      emotion: map['emotion'],
      moodScore: map['moodScore']?.toDouble() ?? 0.0,
      content: map['content'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
