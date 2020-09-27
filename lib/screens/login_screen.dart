import 'package:flutter/material.dart';
import 'package:skype_clone/resources/firebase_repository.dart';

class LoginScreen extends StatefulWidget{
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>{

  FirebaseRepository _repository = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: loginButton(),
    );
  }

  Widget loginButton(){
    return FlatButton(
      padding: EdgeInsets.all(35),
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2
        ),
      ),
      onPressed: () => performLogin,
    );
  }

  void performLogin(){
    
  } 
}