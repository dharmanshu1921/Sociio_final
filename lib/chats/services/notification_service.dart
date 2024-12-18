// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// Future<void> sendNotification(String title, String body) async {
// //
// // // Initialize Firebase Admin app
// //   FirebaseAdmin.initializeApp(
// //       options: FirebaseAdminOptions.fromServiceAccountKey(serviceAccountKey));
// //
// // // Create a message object
// //   final message = MessagingMessage(
// //       notification: MessagingNotification(
// //           title: 'Your Message Title',
// //           body: 'Your Message Body'
// //       ),
// //       token: 'YOUR_DEVICE_TOKEN' // Replace with the recipient's device token
// //   );
// //
// // // Send the message
// //   await messaging.send(message);
// //
// //   print('Message sent successfully!');
//
//
// // //
// // //     // Get the tokens of all users
// // //     final tokensSnapshot = await FirebaseFirestore.instance.collection('userTokens').get();
// // //     final tokens = tokensSnapshot.docs.map((doc) => doc.data()['token']).toList();
// // //
// // //     for (String token in tokens) {
// // //       await _sendNotificationToToken(token, title, body);
// // //     }
// // //
// // // }
// // //
// // // Future<void> _sendNotificationToToken(String token, String title, String body) async {
// // //   final String serverKey = 'BBIXpmo2R2kAvUv4WNKtAAt_QEII4PIIm2fbuxO-oVb1gmyXSVwko1vTi1XRy_tJ4eZH4fBLbWdgxwxfd1U3yZM'; // Replace with your FCM server key
// // //   final String url = 'https://fcm.googleapis.com/fcm/send';
// // //
// // //   final headers = {
// // //     'Content-Type': 'application/json',
// // //     'Authorization': 'key=$serverKey',
// // //   };
// // //
// // //   final data = {
// // //     'notification': {
// // //       'title': title,
// // //       'body': body,
// // //     },
// // //     'priority': 'high',
// // //     'to': token,
// // //   };
// // //
// // //   final response = await http.post(
// // //     Uri.parse(url),
// // //     headers: headers,
// // //     body: json.encode(data),
// // //   );
// // //
// // //   if (response.statusCode == 200) {
// // //     print('Notification sent successfully');
// // //   } else {
// // //     print('Failed to send notification: ${response.body}');
// // //   }
// // }m
