import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post {
  final String date;
  final String title;
  final String description;
  final String hashtags;
  final List<String> images;
  final String postedBy;
  final Timestamp postedOn;
  final String time;
  final String type;
  final List<String> comments;
  final int likes;


  Post({
    required this.title,
    required this.date,
    required this.description,
    required this.hashtags,
    required this.images,
    required this.postedBy,
    required this.postedOn,
    required this.time,
    required this.type,
    required this.comments,
    required this.likes,
  });

  factory Post.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Post(
      date: data['date'] as String,
      description: data['description'] as String,
      hashtags: data['hashtags'] as String,
      images: List<String>.from(data['images'] as List),
      postedBy: data['posted_by'] as String,
      postedOn: data['posted_on'] as Timestamp,
      time: data['time'] as String,
      type: data['type'] as String,
      likes: data['likes'] as int,
      comments: List<String>.from(data['comments'] as List),
      title: data['title'] as String,
    );
  }
}
