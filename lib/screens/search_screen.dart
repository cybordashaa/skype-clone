import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/resources/firebase_repository.dart';
import 'package:skype_clone/screens/chatscreens/chat_screen.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/widgets/custom_tile.dart';

class SearchScreen extends StatefulWidget{

  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>{
  FirebaseRepository _repository = FirebaseRepository();
  List<UserModel> userList;
  String query = "";
  TextEditingController searchController  = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _repository.getCurrentUser().then((User user) {
      _repository.fetchAllUsers(user).then((List<UserModel> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }
  searchAppBar(BuildContext context){
    return GradientAppBar(
      gradient: LinearGradient(colors: [UniversalVariables.gradientColorStart, UniversalVariables.gradientColorEnd]),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0.0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: UniversalVariables.blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.white,),
                onPressed: (){
                  WidgetsBinding.instance.addPostFrameCallback((_) => searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0x88ffffff)
              )
            ),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query){
    final List<UserModel> suggestionList = query.isEmpty
        ? []
        : userList.where((UserModel userModel) {
      String _getUsername = userModel.username.toLowerCase();
      String _query = query.toLowerCase();
      String _getName = userModel.name.toLowerCase();
      bool matchesUsername = _getUsername.contains(_query);
      bool matchesName = _getName.contains(_query);

      return (matchesUsername || matchesName);

      // (User user) => (user.username.toLowerCase().contains(query.toLowerCase()) ||
      //     (user.name.toLowerCase().contains(query.toLowerCase()))),
    }).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index){
        UserModel searchUser  = UserModel(
          uid: suggestionList[index].uid,
          profilePhoto: suggestionList[index].profilePhoto,
          name: suggestionList[index].name,
          username: suggestionList[index].username
        );

        return CustomTile(
          mini: false,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(reciever: searchUser,)));
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchUser.profilePhoto),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            searchUser.username,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
          subtitle: Text(
            searchUser.name,
            style: TextStyle(
              color: UniversalVariables.greyColor
            ),
          ),
        );
      }),
    );
       //  : userList.where((UserModel userModel) =>
       // (userModel.username.contains(query) || userModel.name.toLowerCase().contains(query.toLowerCase())));
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggestions(query),
      ),

    );
  }
}