import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sociio/models/chat_model.dart';

class ChatCacheService {
  static const _cacheKey = 'chatCache';

  Future<void> saveLatestMessageCache(String friendId, String userId, String latestMessage) async {
    final prefs = await SharedPreferences.getInstance();
    final cache = ChatMessage(
      senderId: friendId,
      recipientId: userId,
      message: latestMessage,
      timestamp: DateTime.now(),
    );
    final jsonString = jsonEncode(cache.toJson());
    await prefs.setString(_cacheKey + friendId, jsonString);
  }

  Future<List<ChatMessage>> getAllLatestMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(_cacheKey));
    final caches = keys.map((key) {
      final jsonString = prefs.getString(key);
      return ChatMessage.fromJson(jsonDecode(jsonString!));
    }).toList();
    return caches;
  }

  Future<void> updateChatCache(String currentUserID, String otherUserID, String latestMessage) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _cacheKey + currentUserID + otherUserID;

    // Get the existing cache data
    final existingCache = prefs.getString(key);
    if (existingCache != null) {
      // Parse the JSON string to a map
      final Map<String, dynamic> cacheData = json.decode(existingCache);

      // Update the fields
      cacheData['latestMessage'] = latestMessage;
      cacheData['timestamp'] = DateTime.now().millisecondsSinceEpoch;

      // Save the updated cache back to SharedPreferences
      await prefs.setString(key, json.encode(cacheData));
    }
  }
  Future<void> clearCacheMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(_cacheKey));
    for (var key in keys) {
      await prefs.remove(key);
    }
  }


}
