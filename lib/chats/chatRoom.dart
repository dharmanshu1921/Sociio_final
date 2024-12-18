import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sociio/cacheBuilder/message_cache.dart';
import 'package:sociio/chats/services/chat_service.dart';
import 'package:sociio/models/chat_model.dart';
import 'package:sociio/models/user_model.dart';

class ChatRoom extends StatefulWidget {
  final User sender;
  final User receiver;

  const ChatRoom({Key? key, required this.sender, required this.receiver}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  String? chatId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatId=ChatService().getChatRoomId(widget.sender.uid, widget.receiver.uid);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.arrow_back_rounded, color: Colors.redAccent,),),
        title:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.receiver.uname, style: TextStyle(fontSize: 16),),

            Text(widget.receiver.uid, style: TextStyle(fontSize: 12),),
          ],
        ),
          // Replace with chat name or participant info
        actions: [
          GestureDetector(
            onTap: (){},
            child:             Container(
              margin: const EdgeInsets.only(right: 20.0),
              child: CircleAvatar(radius: 20, backgroundImage: NetworkImage(widget.receiver.uavatar),),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Divider(thickness: 1, color: Color.fromRGBO(255, 255, 255, 0.3),),
          // Message list
          Expanded(
            child:
            StreamBuilder<QuerySnapshot>(
              stream: chatId != null ? ChatService().getMessages(chatId!) : Stream.empty(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  print("no messages");
                  // Show a loading indicator or empty message while waiting for data
                  return Center(child: Text("No messages, start by sending a \"Hi👋\"", style: TextStyle(color: Colors.white),));
                }
                // print(snapshot.data!.docs.first.data());
                // Process data here when snapshot has data
                else{
                  print('here');
                  print(snapshot.data?.docs);
                final messages = snapshot.data!.docs.map((doc) => ChatMessage.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _buildMessage(message);
                  },
                );
                }

              },
            ),

          ),

          // Input field and send button
          Container(
            decoration: BoxDecoration(
              color: Colors.redAccent,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.black54,
                      hintText: "Type your message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    ChatService().sendMessage(chatId!, widget.sender.uid, _messageController.text, widget.receiver.uid);
                    ChatCacheService().saveLatestMessageCache(
                      widget.receiver.uid, widget.sender.uid, _messageController.text, );

                    // Save the message cache
                    print(ChatCacheService().getAllLatestMessages());
                    // Call your send message function (replace with actual logic)
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build individual message widget (replace with your design)
  Widget _buildMessage(ChatMessage message) {
    final isSender = message.senderId == widget.sender.uid; // Replace with actual user ID
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: isSender ? Color(0xFF5A5A5A) : Colors.redAccent,
        ),
        child: Text(message.message, style: TextStyle(fontSize: 20),),
      ),
    );
  }
}

