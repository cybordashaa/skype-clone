
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skype_clone/constants/string.dart';
import 'package:skype_clone/models/message.dart';
import 'package:skype_clone/provider/image_upload_provider.dart';
import 'package:skype_clone/utils/utilities.dart';
import '../models/user.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final CollectionReference  firestore = FirebaseFirestore.instance.collection(USERS_COLLECTION);
  static final CollectionReference firestoreMessage = FirebaseFirestore.instance.collection(MESSAGE_COLLECTION);
  StorageReference _storageReference;

  //user class
  UserModel user = UserModel();

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = await _auth.currentUser;
    return currentUser;
  }

  Future<UserModel> getUserDetails() async {
    User currentUser  = await getCurrentUser();
   DocumentSnapshot documentSnapshot =  await firestore.doc(currentUser.uid).get();
   return UserModel.fromMap(documentSnapshot.data());

  }

  Future<UserCredential> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
    await _signInAccount.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _signInAuthentication.accessToken,
        idToken: _signInAuthentication.idToken);
    final user = await FirebaseAuth.instance.signInWithCredential(credential);
    return user;
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await firestore
        .where("email", isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(User currentUser) async {
    String username = Utils.getUsername(currentUser.email);

    user = UserModel(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoURL,
        username: username);

    firestore
        .doc(currentUser.uid)
        .set(user.toMap(user));
  }

  // Future<void> signOut() async {
  //   await _googleSignIn.disconnect();
  //   await _googleSignIn.signOut();
  //   return await _auth.signOut();
  // }


  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  Future<List<UserModel>> fetchAllUsers(User user) async{
    List<UserModel> userList = List<UserModel>();

    QuerySnapshot querySnapshot = await firestore.get();
    for(var i = 0; i < querySnapshot.docs.length; i++){
      if(querySnapshot.docs[i].id != user.uid){
        userList.add(UserModel.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  Future<void> addMessageToDb(Message message, UserModel sender, UserModel receiver) async {
    try {
      var map = message.toMap();
      await firestoreMessage.doc(message.senderId).collection(
          message.recieverId).add(map);
      return await firestoreMessage.doc(message.recieverId).collection(
          message.senderId).add(map);
    } catch(err){
      print(err);
      return null;
    }
  }

  // image upload to server function
  Future<dynamic> uploadImageToStorage(File image) async{
    _storageReference = FirebaseStorage.instance.ref().child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask _storageUploadTask  = _storageReference.putFile(image);
    var url = (await _storageUploadTask.onComplete).ref.getDownloadURL();
    print(url);
    return url;
  }
  void setImageMsg(String url, String receiverId, String senderId) async{
    Message _message;
    _message = Message.imageMessage(
      message: "IMAGE",
      recieverId: receiverId,
      senderId: senderId,
      photoUrl: url,
      timestamp: Timestamp.now(),
      type: 'image'
    );
    var map  = _message.toMapImageMap();
    // Set the data to database
    await firestoreMessage.doc(_message.senderId).collection(
        _message.recieverId).add(map);
    await firestoreMessage.doc(_message.recieverId).collection(
        _message.senderId).add(map);



  }
  // image upload function
 void uploadImage(File image, String receiverId, String senderId, ImageUploadProvider imageUploadProvider) async {
    // Set some loading value to db and show it to user
   imageUploadProvider.setToLoading();

   // Get url from the image bucket
    String url = await uploadImageToStorage(image);

    //Hide loading
   imageUploadProvider.setToIdle();

    setImageMsg(url, receiverId, senderId);
 }
}