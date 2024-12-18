import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String uid;
  final String uname;
  final String uemail;
  final String uphone;
  final String ugender;
  final String ubio;
  final String uavatar;

  User({
    required this.uid,
    required this.uname,
    required this.uemail,
    required this.uphone,
    required this.ugender,
    required this.ubio,
    required this.uavatar,
  });

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return User(
      uid: data['uid'] as String,
      uname: data['uname'] as String,
      uemail: data['uemail'] as String,
      uphone: data['uphone'] as String,
      ugender: data['ugender'] as String,
      ubio: data['ubio'] as String,
      uavatar: data['uavatar'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'uname': uname,
      'uemail': uemail,
      'uphone': uphone,
      'ugender': ugender,
      'ubio': ubio,
      'uavatar': uavatar,
    };
  }



}