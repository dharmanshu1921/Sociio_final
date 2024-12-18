
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sociio/models/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection name for chat messages
  static const String chatsCollection = 'chats';

  // Subcollection name for messages within a chat
  static const String messagesSubcollection = 'messages';
  List<ChatMessage> _chatUsers = [];


  Future<void> sendMessage(String chatId, String senderId, String message, String receiverId) async {
    final chatRef = _firestore
        .collection(chatsCollection)
        .doc(chatId);
    await chatRef.set({
      'chatRoomId':chatId
    });
    final messageRef = _firestore
        .collection(chatsCollection)
        .doc(chatId)
        .collection(messagesSubcollection)
        .doc();

    await messageRef.set({
      'senderId': senderId,
      'message': message,
      'receiverId': receiverId ,
      'timestamp': DateTime.now(),
    });
  }

  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection(chatsCollection)
        .doc(chatId)
        .collection(messagesSubcollection)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  String getChatRoomId(String senderId, String receiverId){
    List<String> ids=[senderId, receiverId];
    ids.sort();
    return ids.join("_");

  }
  Future<List<ChatMessage>> fetchRecentChats() async {
    final messagesRef = _firestore.collection(chatsCollection);
    final snapshot = await messagesRef.get();

    final List<ChatMessage> users = [];

    for (final doc in snapshot.docs) {
      final chat = doc.data();

      final user = ChatMessage(
         senderId: chat['senderId'], recipientId: chat['recipientId'], message: chat['message'], timestamp: chat['timestamp'],
      );

      users.add(user);
    }
    return users;

  }

  final StreamController<List<ChatMessage>> _controller = StreamController<List<ChatMessage>>();

  Stream<List<ChatMessage>> getRecentChats() {
    fetchRecentChats().then((messages) {
      _controller.add(messages);
    });

    return _controller.stream;
  }

  Future<List<dynamic>> fetchMessagesWithUserId(String userId) async {
    final db = FirebaseFirestore.instance;

    try {
      final snapshot = await db.collection('chats').snapshots();

      final messages = <dynamic>[];

      // for (var doc in snapshot.docs) {
      //   final chatRoomMessages = doc.data()['messages'];
      //   if (chatRoomMessages != null && chatRoomMessages is List) {
      //     messages.addAll(chatRoomMessages);
      //   }
      // }

      return messages;
    } catch (e) {
      print('Error retrieving documents: $e');
      return []; // Return an empty list if an error occurs
    }
  }
  void buildChatCache(String userId) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('chats').get();

    if (snapshot.docs.isEmpty) {
      print('No documents found in the "chats" collection.');
      return;
    }

    final chatCache = <String, String>{};

    for (final doc in snapshot.docs) {
      final chatId = doc.id;
      if (chatId.contains(userId)) {
        final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
        final chatDoc = await chatRef.get();

        if (chatDoc.exists) {
          final msgRef = chatRef.collection('messages').orderBy('timestamp', descending: true);
          final msgDoc = await msgRef.get();

          if (msgDoc.docs.isNotEmpty) {
            final latestMsg = msgDoc.docs.first['message'];
            final otherUserId = msgDoc.docs.first['senderId'] == userId
                ? msgDoc.docs.first['receiverId']
                : msgDoc.docs.first['senderId'];
            final key = '${userId}_$otherUserId';
            chatCache[key] = latestMsg;
          }
        }
      }
    }

    // Update your cache here (e.g., using SharedPreferences)
  }



}