import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String senderId;
  final String recipientId;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.senderId,
    required this.recipientId,
    required this.message,
    required this.timestamp,
  });


  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recipientId': recipientId,
      'message': message,
      'timestamp': timestamp,
    };
  }
  factory ChatMessage.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data() ?? {}; // Use ??= for default empty map
    return ChatMessage(
      senderId: data['senderId'] ?? "", // Provide default values if null
      recipientId: data['recipientId'] ?? "",
      message: data['message'] ?? "",
      timestamp: (data['timestamp'] as Timestamp)!.toDate(), // Use ?. for null-safe conversion
    );
  }
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json['currentUserID'],
      recipientId: json['otherUserID'],
      message: json['latestMessage'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentUserID': senderId,
      'otherUserID': recipientId,
      'latestMessage': message,
      'timestamp': timestamp.toIso8601String(), // Convert DateTime to a string
    };
  }

}


