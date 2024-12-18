import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sociio/cacheBuilder/userProvider.dart';
import 'package:sociio/chats/chatRoom.dart';
import 'package:sociio/models/user_model.dart';

final List<Map<String, dynamic>> messages = [
  {'sender': 'Anubhav Singh', 'message': 'That was cool', 'time': '14:23', 'unread': 4},
  {'sender': 'Chandrika Singh', 'message': 'That was cool', 'time': '13:23', 'unread': 3},
  {'sender': 'Karen Singh', 'message': 'That was cool', 'time': '13:20', 'unread': 3},
];

final List<String> monthAbbreviations = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];

class RecipientTile extends StatefulWidget {
  final String otherUser;
  final String latestMsg;
  final DateTime timestamp;


  const RecipientTile({super.key, required this.otherUser, required this.latestMsg, required this.timestamp,});

  @override
  State<RecipientTile> createState() => _RecipientTileState();
}

class _RecipientTileState extends State<RecipientTile> {
  User? ourUserObj;
  User? otherUserObj;


  void initState() {
    // TODO: implement initState
    super.initState();
    // final userProvider = Provider.of<UserProvider>(context);
    // ourUserObj = userProvider.user;
    // getUserByUid(widget.otherUser).then((user) {
    //   setState(() {
    //     otherUserObj = user;
    //   });
    // });

  }

  Future<User?> getUserByUid(String uid) async {
    final userRef = FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: uid).limit(1).get();

    // Wait for the query to complete and get the snapshot:
    final userSnapshot = await userRef;

    // Check if a document was found:
    if (userSnapshot.docs.isEmpty) {
      return null; // Indicate no user found
    }

    // Extract data from the snapshot and create a User object
    final userDoc = userSnapshot.docs.first;
    final userData = userDoc.data();

    if (userData == null) {
      return null; // Handle potential null data
    }

    return User(
      uid: userData['uid'] as String,
      uname: userData['uname'] as String,
      uemail: userData['uemail'] as String,
      uphone: userData['uphone'] as String,
      ugender: userData['ugender'] as String,
      ubio: userData['ubio'] as String,
      uavatar: userData['uavatar'] as String,
    );
  }

  @override

  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ourUserObj = userProvider.user;

    return FutureBuilder<User?>(
      future: getUserByUid(widget.otherUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container( child: Center(child: CircularProgressIndicator())); // Or other loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          otherUserObj = snapshot.data;
          return
            GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatRoom(sender: ourUserObj!, receiver: otherUserObj!)));
            },
            child:
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all( 8),
              decoration: BoxDecoration(
                  color: Color(0xFF4a4a4a),

                  borderRadius: BorderRadius.circular(20)
              ),
              child: ListTile(

                leading: CircleAvatar(
                  backgroundColor: Colors.red,
                  backgroundImage: NetworkImage(otherUserObj!.uavatar),
                ),
                title: Text(
                  widget.otherUser,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  widget.latestMsg,
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      textAlign: TextAlign.end,
                      "${widget.timestamp.hour}:${widget.timestamp.minute}\n${widget.timestamp.day} ${monthAbbreviations[widget.timestamp.month-1]},${widget.timestamp.year}",
                      style: TextStyle(color: Colors.grey),
                    ),

                    SizedBox(height: 7,),
                    // if (messages.first['unread']! > 0)
                    CircleAvatar(
                      radius: 4.0,
                      backgroundColor: Colors.red,
                      // child: Text(
                      //   '${messages.first['unread']}',
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 12.0,
                      //   ),
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
  // Widget build(BuildContext context) {
  //   return
  // }
}
