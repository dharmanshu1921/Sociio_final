

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sociio/cacheBuilder/userProvider.dart';
import 'package:sociio/models/post_model.dart';
import 'package:sociio/models/user_model.dart';
import 'package:sociio/screens/widgets/post_widget.dart';

class SavedPostPage extends StatefulWidget {
  const SavedPostPage({super.key});

  @override
  State<SavedPostPage> createState() => _SavedPostPageState();
}

class _SavedPostPageState extends State<SavedPostPage> {
  User? user;
  final posts = <Post>[];

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context);
    user = userProvider.user;
    List<String> ids=await getSavedPostIds();
    fetchSavedPosts(ids);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context,index){
        final itemData=posts[index];
        return PostWidget(post: itemData);
      },)
    );
  }
  Future<List<String>> getSavedPostIds() async {

    if (user != null) {
      final savedPostsRef = FirebaseFirestore.instance
          .collection('savedPosts')
          .doc(user!.uid) // Use user.uid for the document ID
          .collection('saved');

      final savedPostsSnapshot = await savedPostsRef.get();
      final savedPostIds = savedPostsSnapshot.docs.map((doc) => doc.id).toList();
      return savedPostIds;
    } else {
      print('Error: User is not signed in');
      return []; // Or handle the case where the user is not signed in
    }
  }
  Future<List<Post>> fetchSavedPosts(List<String> savedPostIds) async {
     // Empty list to store fetched posts

    for (final postId in savedPostIds) {
      final postDoc = await FirebaseFirestore.instance
          .collection('posts')
          .where('title',isEqualTo: postId)
          .get();

      if (postDoc!=null) {
        postDoc.docs.forEach((doc) {
          final post = Post.fromFirestore(doc); // Convert from doc data to your Post object
          posts.add(post);
        });

      } else {
        print('Error: Post with ID $postId not found'); // Handle missing posts
      }
    }

    return posts;
  }

}
