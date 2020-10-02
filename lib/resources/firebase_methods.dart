
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skype_clone/utils/utilities.dart';
import '../models/user.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final CollectionReference  firestore = FirebaseFirestore.instance.collection('users');

  //user class
  UserModel user = UserModel();

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = await _auth.currentUser;
    return currentUser;
  }

  Future<UserCredential> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
    await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _signInAuthentication.accessToken,
        idToken: _signInAuthentication.idToken);
    final user = await FirebaseAuth.instance.signInWithCredential(credential);
    return user;
  }

  Future<bool> authenticateUser(UserCredential user) async {
    QuerySnapshot result = await firestore
        .where("email", isEqualTo: user.user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(UserCredential currentUser) async {
    String username = Utils.getUsername(currentUser.user.email);

    user = UserModel(
        uid: currentUser.user.uid,
        email: currentUser.user.email,
        name: currentUser.user.displayName,
        profilePhoto: currentUser.user.photoUrl,
        username: username);

    firestore
        .document(currentUser.user.uid)
        .setData(user.toMap(user));
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }
}