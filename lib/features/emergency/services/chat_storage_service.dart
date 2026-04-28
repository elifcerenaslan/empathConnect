import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/chat_message.dart';

/// Sohbet geçmişini cihazda saklar.
class ChatStorageService {
  ChatStorageService(this._prefs);

  final SharedPreferences _prefs;

  static const String _sessionsKey = 'empath_chat_sessions_v2';
  static const String _currentSessionIdKey = 'empath_chat_current_session_id';

  static Future<ChatStorageService> create() async {
    final p = await SharedPreferences.getInstance();
    return ChatStorageService(p);
  }

  /// Tüm kayıtlı oturum ID'lerini ve başlıklarını getirir
  List<Map<String, String>> getSessions() {
    final raw = _prefs.getString(_sessionsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => Map<String, String>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Yeni bir oturum oluşturur
  String createNewSession() {
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    _prefs.setString(_currentSessionIdKey, sessionId);
    
    final sessions = getSessions();
    sessions.insert(0, {
      'id': sessionId,
      'title': 'Sohbet - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
    });
    _prefs.setString(_sessionsKey, jsonEncode(sessions));
    return sessionId;
  }

  /// Aktif oturum ID'sini getirir. Yoksa yeni oluşturur.
  String getCurrentSessionId() {
    final id = _prefs.getString(_currentSessionIdKey);
    if (id != null && getSessions().any((s) => s['id'] == id)) {
      return id;
    }
    return createNewSession();
  }

  /// Farklı bir oturuma geçer
  void setCurrentSessionId(String sessionId) {
    _prefs.setString(_currentSessionIdKey, sessionId);
  }

  /// Belirli bir oturumun mesajlarını getirir
  List<ChatMessage> loadMessages(String sessionId) {
    final raw = _prefs.getString('chat_session_$sessionId');
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Belirli bir oturuma mesajları kaydeder
  Future<void> saveMessages(String sessionId, List<ChatMessage> messages) async {
    final encoded =
        jsonEncode(messages.map((m) => m.toJson()).toList(growable: false));
    await _prefs.setString('chat_session_$sessionId', encoded);

    // İlk mesajsa başlığı güncelle
    if (messages.length > 1) { // 0: welcome, 1: first user message
      final userMsg = messages.firstWhere((m) => m.isUser, orElse: () => messages.first);
      if (userMsg.isUser) {
        updateSessionTitle(sessionId, userMsg.text);
      }
    }
  }

  void updateSessionTitle(String sessionId, String firstMessage) {
    final sessions = getSessions();
    final index = sessions.indexWhere((s) => s['id'] == sessionId);
    if (index != -1) {
      // Başlığı ilk mesajın 25 karakteriyle sınırla
      String title = firstMessage.length > 25 ? '${firstMessage.substring(0, 25)}...' : firstMessage;
      sessions[index]['title'] = title;
      _prefs.setString(_sessionsKey, jsonEncode(sessions));
    }
  }

  Future<void> clearAll() async {
    final sessions = getSessions();
    for (var s in sessions) {
      await _prefs.remove('chat_session_${s['id']}');
    }
    await _prefs.remove(_sessionsKey);
    await _prefs.remove(_currentSessionIdKey);
  }
}
