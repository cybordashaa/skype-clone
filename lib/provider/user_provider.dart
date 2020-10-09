
import 'package:flutter/material.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/resources/firebase_repository.dart';

class UserProvider with ChangeNotifier{
  UserModel _user;
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  UserModel get getUser => _user;

  void refreshUser() async{
    UserModel user  = await _firebaseRepository.getUserDetails();
    _user = user;
    notifyListeners();
  }
}