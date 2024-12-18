import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sociio/cacheBuilder/userProvider.dart';
import 'package:sociio/chats/chatRoom.dart';
import 'package:sociio/models/post_model.dart';
import 'package:sociio/models/user_model.dart';
import 'package:sociio/screens/widgets/post_widget.dart';

class UserProfileView extends StatefulWidget {
  final User relatedUser;

  const UserProfileView({super.key, required this.relatedUser});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  var query;

  User? relatedUser;
  User? actualUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    relatedUser= widget.relatedUser;
    query=FirebaseFirestore.instance.collection('posts').where('posted_by', isEqualTo: widget.relatedUser.uid);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context);
    actualUser = userProvider.user;
    print(actualUser);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            // width: MediaQuery.of(context).size.width,

              child: Column(
                children: [

                      Container(
                        height: MediaQuery.of(context).size.height/1.7,
                        child: Stack(children: [
                                Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Image.asset(
                              'assets/Images/setbg.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                                ),
                                Positioned(
                            top: MediaQuery.of(context).size.height * 0.2,
                            left: 0,
                            right: 0,
                            child:  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                  Center(
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 48,
                                          backgroundImage: NetworkImage(relatedUser == null
                                              ? "https://t4.ftcdn.net/jpg/03/40/12/49/360_F_340124934_bz3pQTLrdFpH92ekknuaTHy8JuXgG7fi.jpg"
                                              : relatedUser!.uavatar),
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${relatedUser == null ? "Test Username" : relatedUser!.uname}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatRoom(sender: actualUser!, receiver: relatedUser!)));
                                              },
                                              icon: Icon(
                                                Icons.mail_outline_rounded,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              style: IconButton.styleFrom(
                                                  side: BorderSide(color: Colors.white),
                                                  backgroundColor: Colors.redAccent),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '${relatedUser == null ? "Test UserID" : relatedUser!.uid}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "@BML Munjal University",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromRGBO(255, 255, 255, 0.5)),
                                        ),
                                        SizedBox(height: 20),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 18),
                                          child: Text(
                                            '${relatedUser == null ? "Test User Bio" : relatedUser!.ubio}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                                    child: Divider(
                                      color: Colors.white,
                                      thickness: 1,
                                    ),
                                  ),
                                ])),
                                Positioned(
                          top: 30,
                          left: 10,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: IconButton.styleFrom(backgroundColor: Colors.black),
                          ),
                                ),

                        ]),
                      ),


              

                        Text("Posts", style: TextStyle(fontSize: 18, color: Colors.white),),
                        Expanded(

                          child: StreamBuilder<QuerySnapshot>(
                              stream: query.snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                if (!snapshot.hasData) {
                                  return Center(child: CircularProgressIndicator());
                                }

                                final allPosts = snapshot.data!.docs.map((doc) => Post.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
                                // if(widget.showType=="achievement"){
                                //   filteredPosts = allPosts.where((post) => post.type == "achievement").toList();
                                //
                                // } else if(widget.showType=="event"){
                                //   filteredPosts = allPosts.where((post) => post.type == "event").toList();
                                //
                                // } else{
                                //   filteredPosts=allPosts;
                                // }
                                return  allPosts.length==0?Container(padding: EdgeInsets.all(20), child: Center(child: Text("No Posts Found from user")),): ListView.builder(
                                  itemCount: allPosts.length,
                                  itemBuilder: (context, index) {
                                    return PostWidget(post: allPosts[index]);
                                  },

                                );
                              }),)


              

                ],
              ),

          ),
        ),
    
    );
  }
}
