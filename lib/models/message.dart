import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String recieverId;
  String type;
  String message;
  FieldValue timestamp;
  String photoUrl;

  Message({this.senderId,this.recieverId, this.type, this.message, this.timestamp,this.photoUrl});
  // Will be only called when you wish to send an image
  Message.imageMessage({this.senderId, this.recieverId, this.message, this.type, this.timestamp, this.photoUrl});

  Map toMap(){
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['recieverId'] = this.recieverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    return map;
  }
  Message fromMap(Map<String, dynamic> map){
    Message _message = Message();
    _message.senderId = map['senderId'];
    _message.recieverId = map['recieverId'];
    _message.type = map['type'];
    _message.message = map['message'];
    _message.timestamp = map['timestamp'];
    return _message;
  }
}