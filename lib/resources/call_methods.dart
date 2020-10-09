import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skype_clone/constants/string.dart';
import 'package:skype_clone/models/call.dart';

class CallMethods {

  final CollectionReference callCollection = FirebaseFirestore.instance.collection(CALL_COLLECTION);

  Stream<DocumentSnapshot> callStream({String uid}) => callCollection.doc(uid).snapshots();
  Future<bool> makeCall({Call call}) async {
    try{
      Map<String, dynamic> hasDialledMap = call.toMap(call);
      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;

    }catch(err){
      print(err);
      return false;
    }
  }
  Future<bool> endCall({Call call}) async {
    try{
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      return true;
    }catch(err){
      print(err);
      return false;
    }
  }
}