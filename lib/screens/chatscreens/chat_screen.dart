import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/constants/string.dart';
import 'package:skype_clone/models/message.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/resources/firebase_repository.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/widgets/appBar.dart';
import 'package:skype_clone/widgets/custom_tile.dart';

class ChatScreen extends StatefulWidget{
  final UserModel reciever;
  ChatScreen({this.reciever});
  _ChatScreenState createState()=> _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{
  TextEditingController textFieldController  = TextEditingController();
  bool isWriting = false;
  FirebaseRepository _repository = FirebaseRepository();
  UserModel sender;
  String _currentUserId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getCurrentUser().then((user) {
      _currentUserId = user.uid;
      setState(() {
        sender = UserModel(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoURL,
        );
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: [
          Flexible(
            child: messageList(),
          ),
          chatControls(),
        ],
      ),
    );
  }

  Widget messageList(){
    CollectionReference messages = FirebaseFirestore.instance.collection(MESSAGE_COLLECTION);
    return StreamBuilder<QuerySnapshot>(
      stream: messages.doc(_currentUserId).collection(widget.reciever.uid).orderBy(TIMESTAMP_FIELD, descending: false).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.data == null){
          return Center(child: CircularProgressIndicator(),);
        }
        return ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
            return chatMessageItem(snapshot.data.docs[index]);
          },
        );
      },
    );
  }
  Widget chatMessageItem(DocumentSnapshot snapshot){
    Message _message  = Message.fromMap(snapshot.data());

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: _message.senderId == _currentUserId ? Alignment.centerRight : Alignment.centerLeft,
        child: _message.senderId == _currentUserId ? senderLayout(_message) : receiverLayout(_message),
      ),
    );
  }

  Widget senderLayout(Message message){
    Radius messageRadius = Radius.circular(10.0);
    return Container(
      margin: EdgeInsets.only(
        top: 12
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65
      ),
      decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius
        )
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }
  getMessage(Message message){
    return Text(
      message.message,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,

      ),
    );
  }
  Widget receiverLayout(Message message){
    Radius messageRadius = Radius.circular(10.0);
    return Container(
      margin: EdgeInsets.only(
          top: 12
      ),
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65
      ),
      decoration: BoxDecoration(
          color: UniversalVariables.receiverColor,
          borderRadius: BorderRadius.only(
              topLeft: messageRadius,
              topRight: messageRadius,
              bottomLeft: messageRadius
          )
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }
  Widget chatControls(){
    setWritingTo(bool val){
      setState(() {
        isWriting = val;
      });
    }
    Widget addMediaModal(context){
      showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: UniversalVariables.blackColor,
        builder: (context){
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    FlatButton(
                      child: Icon(
                        Icons.close
                      ),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Content and tools",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  children: [
                    ModalTile(
                      title: 'Media',
                      subtitle: 'Share Photos and Video',
                      icon: Icons.image,
                    ),
                    ModalTile(
                      title: 'File',
                      subtitle: 'Share Files',
                      icon: Icons.tab,
                    ),
                    ModalTile(
                      title: 'Contact',
                      subtitle: 'Share Contact',
                      icon: Icons.contacts,
                    ),
                    ModalTile(
                      title: 'Location',
                      subtitle: 'Share a Location',
                      icon: Icons.add_location,
                    ),
                    ModalTile(
                      title: 'Schedule call',
                      subtitle: 'Arrange a skype call and get reminders',
                      icon: Icons.schedule,
                    ),
                    ModalTile(
                      title: 'Create Poll',
                      subtitle: 'Share polls ',
                      icon: Icons.poll,
                    )
                  ],
                ),
              )
            ],
          );
        }
      );
    }
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
         GestureDetector(
           onTap: () => addMediaModal(context),
           child: Container(
             padding: EdgeInsets.all(5),
             decoration: BoxDecoration(
               gradient: UniversalVariables.fabGradient,
               shape: BoxShape.circle
             ),
             child: Icon(Icons.add),
           ),
         ),
          SizedBox(width: 5,),
          Expanded(
            child: TextField(
              controller: textFieldController,
              style: TextStyle(
                color: Colors.white
              ),
              onChanged: (val){
                (val.length > 0 && val.trim() != "") ? setWritingTo(true) : setWritingTo(false);
              },
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(
                  color: UniversalVariables.greyColor
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(const Radius.circular(50.0)),
                  borderSide: BorderSide.none
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                filled: true,
                fillColor: UniversalVariables.separatorColor,
                suffixIcon: GestureDetector(
                  onTap: (){

                  },
                  child: Icon(Icons.face),
                )
              ),
            ),
          ),
          isWriting ? Container() : Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.record_voice_over),
          ),
          isWriting ? Container() : Icon(Icons.camera_alt),
          isWriting ? Container(margin: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              gradient: UniversalVariables.fabGradient,
              shape: BoxShape.circle
            ),
            child: IconButton(
              icon: Icon(
                Icons.send,
                size: 15,
              ),
              onPressed: () => sendMessage(),
            ),
          ): Container()
        ],
      ),
    );
  }
  sendMessage(){
    var text = textFieldController.text;
    Message _message  = Message(
      recieverId: widget.reciever.uid,
      senderId: sender.uid,
      message: text,
      timestamp: Timestamp.now(),
      type: 'text',
    );
    setState(() {
      isWriting = false;
    });
    textFieldController.text = "";
    _repository.addMessageToDb(_message, sender, widget.reciever);
  }

  CustomAppBar customAppBar(context){
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.reciever.name
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.video_call
          ),
          onPressed: (){},
        ),
        IconButton(
          icon: Icon(
            Icons.phone,
          ),
          onPressed: (){},
        )
      ],

    );
  }
}

class ModalTile extends StatelessWidget{
  final String title;
  final String subtitle;
  final IconData icon;
  const ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon
});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38.0,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14
          ),
        ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ) ,
      ),
    );
  }
}