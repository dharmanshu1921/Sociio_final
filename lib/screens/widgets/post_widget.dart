import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sociio/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:sociio/models/user_model.dart';
import 'package:sociio/userProfile_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../cacheBuilder/likedpost_cache.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  const PostWidget({required this.post});
  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late final Post post; // Declare 'post' as 'late'
  User? user;
  bool _isExpanded = false;
  bool saved=false;
  int _currentImageIndex = 0;
  bool liked2=false;
  int likeCount=0;
  @override
  void initState() {
    super.initState();
    post = widget.post; // Access 'post' within initState
    fetchCreator(post.postedBy).then((value) {
      setState(() {
        user = value;
      });
    }).catchError((error) {
      print('Error fetching user: $error');
    });
    likeCount=post.likes;
  }


  @override
  Widget build(BuildContext context) {

    return user == null ? Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color(0xFF4a4a4a),
          borderRadius: BorderRadius.circular(10)
      ),
      child: CircularProgressIndicator(color: Colors.redAccent,),
    ): _buildPostWidget();
  }


  Widget _buildPostWidget() {
    bool liked = Provider.of<LikeState>(context).isLiked(post.title+post.postedBy);
          return Container(
            padding: const EdgeInsets.all(12.0),
            margin: EdgeInsets.all( 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade400, Colors.red.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfileView(relatedUser: user!)));
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            // user==null?"assets/Images/avatar.png":
                            user!.uavatar),
                        radius: 20,
                      ),
                    ),
                    SizedBox(width: 8),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user!.uname,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            user!.uid
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(getRelativeTimeText(post.postedOn.toDate())),

                    // Text(post.postedOn.toString()),
                  ],
                ),
                const SizedBox(height:12),
                Column(
                  children: [
                    Visibility(child: Text(post.title, style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                    Text(
                      maxLines: _isExpanded ? 10 : 3,
                      overflow: TextOverflow.ellipsis,
                      post.description.toString(),
                      style: TextStyle(
                          fontSize: 16,
                      ),

                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded; // Toggle the expanded state
                        });
                      },
                      child: Text(
                        _isExpanded ? 'Read Less' : 'Read More',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Text(

                    post.hashtags.toString()
                ),

                const SizedBox(height: 8),
                Visibility(
                  visible: post.type=="event",
                  child: Container(
                    width: 200,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFF2a2a2a),
                      borderRadius: BorderRadius.circular(10),

                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.white,),
                            SizedBox(width: 4,),
                            Text(post.time, style: TextStyle(color: Colors.white),)
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.date_range, color: Colors.white,),
                            SizedBox(width: 4,),

                            Text(post.date, style: TextStyle(color: Colors.white),)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Image.network("assets/Images/image 5.png", height: 200,width: 200),
                Stack(
                  children: [
                    CarouselSlider(
                      items: post.images.map((imageUrl) {
                        return Container(
                          height: 200,
                          width: 500,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            image: DecorationImage(
                              image: NetworkImage(imageUrl, ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }).toList(),
                      carouselController: CarouselController(),
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height / 3,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: post.images.length > 1,
                        onPageChanged: (index, reason) => (() => _currentImageIndex = index),
                      ),
                    ),
                    Positioned(
                      bottom: 20.0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: post.images.asMap().entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Container(
                              width: 8.0,
                              height: 8.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImageIndex == entry.key ? Colors.white : Colors.grey,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(0.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade900, Colors.red.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                        },
                        icon: const Icon(Icons.message),
                        padding: const EdgeInsets.all(0.0),
                      ),
                      Text(post.comments.length.toString()),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async{
                              setState(() {
                                liked2=!liked2;
                                if(liked2==false && (liked)==false){
                                  likeCount=post.likes-1;
                                } else{
                                  likeCount=post.likes+1;

                              }});
                              bool newLiked = !liked;
                              Provider.of<LikeState>(context, listen: false).setLiked(post.title+post.postedBy, newLiked);

                              await likeCountUpdate(newLiked, post.title);
                              setState(() {
                                liked=newLiked;
                              });
                            },

                            icon:  Icon(liked==true?Icons.favorite:Icons.favorite_border),
                            padding: const EdgeInsets.all(0.0),
                          ),
                          Text(
                            likeCount.toString()
                          ),
                        ],
                      ),
                      const Spacer(),
                      // IconButton(
                      //   onPressed: () {
                      //   },
                      //   icon: const Icon(Icons.send),
                      //   padding: const EdgeInsets.all(0.0),
                      // ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            saved=!saved;
                          });
                          if(saved==true){
                             savePost(post.title);
                          }
                          else{
                            removePost(post.title);
                          }

                        },
                        icon:  Icon(saved==true?Icons.bookmark:Icons.bookmark_border),
                        padding: const EdgeInsets.all(0.0),
                      ),
                      Visibility(
                        visible: post.type=="achievement"?false:true,
                        child: IconButton(
                          onPressed: () {
                            _launchGoogleCalendar(post.title,post.description, post.date, post.time);
                          },
                          icon: const Icon(Icons.calendar_today),
                          padding: const EdgeInsets.all(0.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

        }

  Future<void> savePost(String postId) async {

    if (user != null) {
      // Get a reference to the user's saved posts collection
      final savedPostsRef = FirebaseFirestore.instance
          .collection('savedPosts')
          .doc(user!.uid) // Use user.uid for the document ID
          .collection('saved');

      // Check if the post is already saved (optional)
      final savedPostDoc = await savedPostsRef.doc(postId).get();
      if (savedPostDoc.exists) {
        print('Post already saved!');
        return; // Or handle the case where the post is already saved
      }

      // Create a new document with the post ID in the "saved" array
      await savedPostsRef.doc(postId).update({
        'saved': FieldValue.arrayUnion([postId]), // Add the post ID to the array
      });

      // await savedPostsRef.doc(postId).set({
      //   'saved': [postId], // Initial array with the post ID
      // });

      print('Post saved successfully!');
    } else {
      print('Error: User is not signed in');
    }
  }

  Future<void> removePost(String postId)async{
    final savedPostsRef = FirebaseFirestore.instance
        .collection('savedPosts')
        .doc(user!.uid) // Use user.uid for the document ID
        .collection('saved');
    await savedPostsRef.doc(postId).update({
      'saved': FieldValue.arrayRemove([postId]), // Remove the post ID from the array
    });


  }
  }

  int getDifferenceInMinutes(DateTime postDateTime) {
    final now = DateTime.now();
    final difference = now.difference(postDateTime);
    return difference.inMinutes.abs(); // Get absolute value of minutes
  }
  String getRelativeTimeText(DateTime postTime) {
      final now = DateTime.now();
      final difference = now.difference(postTime);

      final minutes = difference.inMinutes;
      if (minutes == 0) {
        return 'just now';
      } else if (minutes < 60) {
        return '$minutes minute${minutes > 1 ? 's' : ''} ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else {
        // Display days
        final days = difference.inDays;
        return '$days day${days > 1 ? 's' : ''} ago';
      }

  }
  
  Future<void> likeCountUpdate( bool addLike, String title)async {
    final postRef = FirebaseFirestore.instance.collection('posts').where('title', isEqualTo: title);

    // Fetch the document snapshot
    final querySnapshot = await postRef.get();
    final document = querySnapshot.docs.first;

    // Update the like count
    int currentLikes = document['likes'] ?? 0;
    int newLikes = addLike ? currentLikes + 1 : currentLikes - 1;

    // Ensure newLikes count doesn't go below 0
    if (newLikes < 0) {
      newLikes = 0;
    }

    // Update the like count in Firestore
    await document.reference.update({'likes': newLikes});
  }

  Future<User> fetchCreator(String postedBy) async {
    // Reference to the Firestore collection 'users'
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Query the collection for the user with 'postedBy' equal to the specified value
    QuerySnapshot userQuery = await users.where('uid', isEqualTo: postedBy).get();

    // Check if any documents match the query
    if (userQuery.docs.isNotEmpty) {
      // Get the first document (assuming 'postedBy' is unique)
      Map<String, dynamic> userData = userQuery.docs.first.data() as Map<String, dynamic>;

         return User(
          uid: userData['uid'],
          uname: userData['uname'],
          uemail: userData['uemail'],
          uphone: userData['uphone'],
          ugender: userData['ugender'],
          ubio: userData['ubio'],
          uavatar: userData['uavatar'],
        );
    } else {
      throw Exception('User not found');
    }
  }



void _launchGoogleCalendar(String title, String description, String date, String time) async {
  String urlPartDT=convertToGoogleCalendarFormat(date, time);
  String formattedEventTitle = Uri.encodeComponent(title);
  String formattedEventDesc= Uri.encodeComponent(description);

  String appUrl = 'https://www.google.com/calendar/render?action=TEMPLATE&text=Meeting%20with%20Team&dates=20220517T140000Z/20220517T150000Z&details=Discuss%20project%20status&location=Conference%20Room';
  const webUrl = 'https://calendar.google.com/calendar/';

  if (await canLaunch(appUrl)) {
    await launch(appUrl);
  } else {
    if (await canLaunch(webUrl)) {
      await launch(webUrl);
    } else {
      throw 'Could not launch $webUrl';
    }
  }
}

String convertToGoogleCalendarFormat(String date, String time) {
  List<String> dateParts = date.split('/');
  String day = dateParts[0].padLeft(2, '0');
  String month = dateParts[1].padLeft(2, '0');
  String year = dateParts[2];

  List<String> timeParts = time.split(':');
  String hour = timeParts[0].padLeft(2, '0');
  String minute = timeParts[1].padLeft(2, '0');

  return '${year}${month}${day}T${hour}${minute}00Z';
}



String _formatDateTime(DateTime dateTime) {
  return '${dateTime.year}${dateTime.month.toString().padLeft(2, '0')}${dateTime.day.toString().padLeft(2, '0')}T${dateTime.hour.toString().padLeft(2, '0')}${dateTime.minute.toString().padLeft(2, '0')}00';
}



