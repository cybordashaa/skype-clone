import 'package:flutter/material.dart';
import 'package:skype_clone/resources/firebase_repository.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/utils/utilities.dart';
import 'package:skype_clone/widgets/appBar.dart';

class ChatListScreen extends StatefulWidget{
  _ChatListScreenState   createState()=> _ChatListScreenState();
}

// global
final FirebaseRepository _repository = FirebaseRepository();
class _ChatListScreenState extends State<ChatListScreen>{
  String currentUserId;
  String initials;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUserId = user.uid;
        initials  = Utils.getInitials(user.displayName);
      });
    });
  }
  CustomAppBar customAppBar(BuildContext context){
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
            Icons.notifications,
          color: Colors.white,
        ),
        onPressed: (){},
      ),
      title: UserCircle(initials),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: (){},
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: (){},
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
    );
  }
}

class UserCircle extends StatelessWidget{
  final String text;
  UserCircle(this.text);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 40.0,
      width: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: UniversalVariables.separatorColor
      ),
      child: Stack(
        children:<Widget> [
          Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: UniversalVariables.lightBlueColor,
                fontSize: 13
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: UniversalVariables.blackColor,
                  width: 2
                ),
                color: UniversalVariables.onlineDotColor
              ),
            ),
          )
        ],
      ),
    );
  }
}