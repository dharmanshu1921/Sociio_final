import 'package:flutter/material.dart';
import 'package:sociio/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  UserProvider({User? user}) : _user = user;

  void updateUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }
}

