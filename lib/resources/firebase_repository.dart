import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/models/message.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/provider/image_upload_provider.dart';
import 'package:skype_clone/resources/firebase_methods.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<User> getCurrentUser() => _firebaseMethods.getCurrentUser();
  Future<UserModel> getUserDetails() => _firebaseMethods.getUserDetails();

  Future<UserCredential> signIn() => _firebaseMethods.signIn();

  Future<bool> authenticateUser(User user) =>
      _firebaseMethods.authenticateUser(user);

  Future<void> addDataToDb(User user) => _firebaseMethods.addDataToDb(user);

  // responsible for signing out
Future<void> signOut() => _firebaseMethods.signOut();

  Future<List<UserModel>> fetchAllUsers(User user) => _firebaseMethods.fetchAllUsers(user);
  Future<void> addMessageToDb(Message message, UserModel sender, UserModel receiver) => _firebaseMethods.addMessageToDb(message, sender, receiver);

  // image upload function
void uploadImage({
  @required File image,
  @required String receiverId,
  @required String senderId,
  @required ImageUploadProvider imageUploadProvider}) => _firebaseMethods.uploadImage(image, receiverId, senderId, imageUploadProvider);
}
