import 'package:flutter/material.dart';

class LikeState extends ChangeNotifier {
  Map<String, bool> _likedMap = {};

  bool isLiked(String postId) {
    return _likedMap[postId] ?? false;
  }

  void setLiked(String postId, bool liked) {
    _likedMap[postId] = liked;
    notifyListeners();
  }
}
