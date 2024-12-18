import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sociio/models/post_model.dart';
import 'package:sociio/screens/widgets/post_widget.dart';

class Recent extends StatefulWidget {
  final showType;
  const Recent({Key? key, required this.showType}) : super(key: key);

  @override
  State<Recent> createState() => _RecentState();
}

class _RecentState extends State<Recent> {

  final query = FirebaseFirestore.instance.collection('posts').orderBy('posted_on', descending: true);

  var filteredPosts;
  // @override
  // void initState() {
  //   super.initState();
  //   _posts = fetchPosts();
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }

      final allPosts = snapshot.data!.docs.map((doc) => Post.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      if(widget.showType=="achievement"){
         filteredPosts = allPosts.where((post) => post.type == "achievement").toList();

      } else if(widget.showType=="event"){
        filteredPosts = allPosts.where((post) => post.type == "event").toList();

      } else{
        filteredPosts=allPosts;
      }
      return  filteredPosts.length==0?Container(padding: EdgeInsets.all(20), child: Center(child: Text("No Posts Found for ${widget.showType}")),): ListView.builder(
        itemCount: filteredPosts.length,
        itemBuilder: (context, index) {
          return PostWidget(post: filteredPosts[index]);
        },

    );
  }));
  }

  Future<List<Post>> fetchPosts() async {
    final postsCollection = FirebaseFirestore.instance.collection('posts');

    final snapshot = await postsCollection.get();
    print("\n-----\nSNAPSHOT: ${snapshot.docs}");
    return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
  }

}

// Widget postCard(BuildContext context) {
//   return Container(
//     padding: const EdgeInsets.all(12.0),
//     decoration: BoxDecoration(
//       gradient: LinearGradient(
//         colors: [Colors.red.shade400, Colors.red.shade800],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//       borderRadius: BorderRadius.circular(20.0),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.red.withOpacity(0.5),
//           spreadRadius: 1,
//           blurRadius: 3,
//           offset: const Offset(0, 3),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(20.0),
//               child: Image.asset("assets/Images/avatar.png", height: 40, width: 40),
//             ),
//             SizedBox(width: 8),
//             Text('Karen Singh'),
//             Spacer(),
//             Text('Just Now'),
//           ],
//         ),
//         const SizedBox(height: 8),
//         const Text(
//           'Post (also see tweet) - Content shared on social media through a user\'s profile. It can be as simple as a blurb of text, but can also include images, videos, and links to other content. Other users of the social network can like, comment, and share the post.',
//         ),
//         const SizedBox(height: 8),
//         Image.asset("assets/Images/image 5.png", height: 200,width: 200),
//         const SizedBox(height: 8),
//         Container(
//           padding: const EdgeInsets.all(0.0),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.red.shade900, Colors.red.shade600],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(20.0),
//               bottomRight: Radius.circular(20.0),
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               IconButton(
//                 onPressed: () {
//                 },
//                 icon: const Icon(Icons.message),
//                 padding: const EdgeInsets.all(0.0),
//               ),
//               const Text('10'),
//               Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                     },
//                     icon: const Icon(Icons.favorite),
//                     padding: const EdgeInsets.all(0.0),
//                   ),
//                   const Text('122'),
//                 ],
//               ),
//               const Spacer(),
//               IconButton(
//                 onPressed: () {
//                 },
//                 icon: const Icon(Icons.send),
//                 padding: const EdgeInsets.all(0.0),
//               ),
//               IconButton(
//                 onPressed: () {
//                 },
//                 icon: const Icon(Icons.bookmark),
//                 padding: const EdgeInsets.all(0.0),
//               ),
//               IconButton(
//                 onPressed: () {
//                 },
//                 icon: const Icon(Icons.calendar_today),
//                 padding: const EdgeInsets.all(0.0),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
//
//
// }
