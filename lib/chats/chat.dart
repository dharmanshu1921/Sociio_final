
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sociio/cacheBuilder/message_cache.dart';
import 'package:sociio/cacheBuilder/userProvider.dart';
import 'package:sociio/chats/services/chat_service.dart';
import 'package:sociio/chats/widgets/recipient_tile.dart';
import 'package:sociio/models/chat_model.dart';
import 'package:sociio/models/user_model.dart';
import 'package:sociio/switch_chat_view.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  User? user;
  List<ChatMessage>? chats = [];
  List<Map<String, dynamic>>? messagesAll;
  List<Map<String, dynamic>> messages = [];

  // final List<Map<String, String>> pinnedContacts = [
  //   {'name': 'Kim', 'avatar': 'assets/Images/avatar.png'},
  //   {'name': 'Steve', 'avatar': 'assets/Images/steve.jpeg'},
  //   {'name': 'Mia', 'avatar': 'assets/Images/mia.jpeg'},
  // ];

  List<ChatMessage> cachedMessages=[];

  // final List<Map<String, dynamic>> messages = [
  //   {'sender': 'Anubhav Singh', 'message': 'That was cool', 'time': '14:23', 'unread': 4},
  //   {'sender': 'Chandrika Singh', 'message': 'That was cool', 'time': '13:23', 'unread': 3},
  //   {'sender': 'Karen Singh', 'message': 'That was cool', 'time': '13:20', 'unread': 3},
  // ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context);
    user = userProvider.user;

  }
  Future<void> _loadCachedMessages() async {
    final messages = await ChatCacheService().getAllLatestMessages();
    setState(() {
      cachedMessages = messages;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _loadCachedMessages();
  }

  @override
  Widget build(BuildContext context) {
    print(cachedMessages);
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),

      body:
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(8),
        child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user!.uavatar),
                  ),
                  SizedBox(width: 20,),
                  Text("Messages", style: TextStyle(fontSize: 20),),
                  // SwitchChatView(),
                  SizedBox(width: 20,),
                  IconButton(onPressed: (){}, icon: Icon(Icons.search_rounded), style: IconButton.styleFrom(
                    shape: CircleBorder(side: BorderSide(color: Color(0xFF4a4a4a)),  ), backgroundColor:Color(0xFF4a4a4a)
                  ),),

                ],
              ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Your personal messages are',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        Text(
                          ' end-to-end-encrypted',
                          style: TextStyle(color: Colors.red, fontSize: 13),
                        ),

                      ],
                    ),
                  ),
                  Divider(color: Color.fromRGBO(255, 255, 255, 0.2), thickness: 0.5,),
              // chats!.isEmpty
              //     ? Container(child: Center(child: Text('You haven\'t sent any messages so far...'))) // Show placeholder
              //     :

    StreamBuilder<List<ChatMessage>>(
    stream: getChatsStream(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(
    child: Text("Loading Messages..."),
    );
    }

    if (snapshot.hasError) {
    return Center(
    child: Text('Error: ${snapshot.error}'),
    );
    }

    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
    final chats = snapshot.data!;

    return Expanded(
    child: ListView.builder(
    itemCount: chats.length,
    itemBuilder: (context, index) {
    final message = chats[index];
    // Display the chat message details (e.g., sender, message, timestamp)
    return RecipientTile(
    otherUser: message.recipientId,
    latestMsg: message.message,
    timestamp: message.timestamp,
    );
    },
    ),
    );
    }

    // Handle empty state
    return Center(
    child: Container(
    padding: EdgeInsets.all(30),
    child: Text(
    "You currently have no messages, start by sending a 'Hi'",
    textAlign: TextAlign.center,
    ),
    ),
    );
    },

    )])));
  }
  Stream<List<ChatMessage>> getChatsStream() async* {
    final chats = <ChatMessage>[];
    final querySnapshot = await FirebaseFirestore.instance.collection("chats").get();
    final filteredMessagesCollections = querySnapshot.docs.where((messageCollection) => messageCollection.id.contains(user!.uid));
    print(filteredMessagesCollections.length);

    for (var messageCollection in filteredMessagesCollections) {
      final latestMessageSnapshot = await messageCollection.reference.collection("messages").orderBy('timestamp', descending: true).get();

      if (latestMessageSnapshot.docs.isNotEmpty) {
        final latestMessageDocs = latestMessageSnapshot.docs;
        print(latestMessageDocs.length);
        for (var data in latestMessageDocs) {
          final latestMessageDoc = data.data();
          final timestamp = (latestMessageDoc['timestamp'] as Timestamp).toDate();

          final chat = ChatMessage(
            recipientId: latestMessageDoc['receiverId'],
            senderId: latestMessageDoc['senderId'],
            timestamp: timestamp,
            message: latestMessageDoc['message'],
          );
          chats.add(chat);
        }
        // Yield the updated list of chats whenever there's a change
        yield chats;
      }
    }
    yield chats; // Emit the initial list of chat messages
  }

// Future<void> buildChatMessagesList()async{
  //
  //   final querySnapshot = await FirebaseFirestore.instance.collection("chats").get();
  //   final filteredMessagesCollections = querySnapshot.docs.where((messageCollection) => messageCollection.id.contains(user!.uid)).toList();
  //   for (var messageCollection in filteredMessagesCollections) {
  //     // Create a subcollection query to get the latest message
  //     final latestMessageQuery = messageCollection.reference
  //         .collection('messages')
  //         .orderBy('timestamp',
  //         descending: true) // Order by timestamp in descending order
  //         .limit(1); // Limit the results to 1 (latest message)
  //
  //     // Get the latest message snapshot
  //     final latestMessageSnapshot = await latestMessageQuery.get();
  //
  //     // Check if a message exists
  //     if (latestMessageSnapshot.docs.isNotEmpty) {
  //       final latestMessageDoc = latestMessageSnapshot.docs.first;
  //
  //       // Access the message data
  //       final latestMessage = latestMessageDoc.data();
  //       final timestamp = (latestMessage['timestamp'] as Timestamp)?.toDate();
  //
  //       final chat = ChatMessage(
  //         recipientId: latestMessage['receiverId'],
  //         senderId: latestMessage['senderId'], // Replace 'text' with actual field name
  //         timestamp: timestamp!,
  //         message: latestMessage['message']
  //       );
  //
  //       // Add the Chat object to a list
  //       chats?.add(chat);
  //       // Process the latest message (e.g., display it)
  //       print(
  //           'Latest message: ${latestMessage['message']}'); // Replace 'text' with the actual field name in your messages
  //     } else {
  //       // Handle the case where no messages exist in the collection
  //       print('No messages found for chat: ${messageCollection.id}');
  //     }
  //   }
  //   print(chats);
  // }
}
