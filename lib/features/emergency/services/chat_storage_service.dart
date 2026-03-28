import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/chat_message.dart';

/// Sohbet geçmişini cihazda saklar.
class ChatStorageService {
  ChatStorageService(this._prefs);

  final SharedPreferences _prefs;

  static const String _storageKey = 'empath_chat_messages_v1';

  static Future<ChatStorageService> create() async {
    final p = await SharedPreferences.getInstance();
    return ChatStorageService(p);
  }

  List<ChatMessage> loadMessages() {
    final raw = _prefs.getString(_storageKey);
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

  Future<void> saveMessages(List<ChatMessage> messages) async {
    final encoded =
        jsonEncode(messages.map((m) => m.toJson()).toList(growable: false));
    await _prefs.setString(_storageKey, encoded);
  }

  Future<void> clear() async {
    await _prefs.remove(_storageKey);
  }
}
