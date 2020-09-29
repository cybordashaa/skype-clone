import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/utils/universal_variables.dart';

class HomeScreen extends StatefulWidget{
  HomeScreenState createState() => HomeScreenState();
}
class HomeScreenState extends State<HomeScreen>{
  PageController pageController;
  int _page  = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController  = PageController();
  }
  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }
  void navigationTapped(int page){
    pageController .jumpToPage(page);
  }
  @override
  Widget build(BuildContext context) {
    double _labelFontSize  = 10;
    // TODO: implement build
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: PageView(
        children:<Widget> [
          Center(child: Text("Chat List Screen"),),
          Center(child: Text("Call Logs"),),
          Center(child: Text("Contact Screen"),)
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CupertinoTabBar(
            backgroundColor: UniversalVariables.blackColor,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.chat, color: (_page == 0) ? UniversalVariables.lightBlueColor : UniversalVariables.greyColor),
                title: Text(
                  "Chats",
                  style: TextStyle(
                    fontSize: _labelFontSize,
                    color: (_page == 0) ? UniversalVariables.lightBlueColor : UniversalVariables.greyColor
                  ),
                )
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.call, color: (_page == 1) ? UniversalVariables.lightBlueColor : UniversalVariables.greyColor),
                  title: Text(
                    "Calls",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 1) ? UniversalVariables.lightBlueColor : UniversalVariables.greyColor
                    ),
                  )
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contact_phone,
                    color: (_page == 2)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor),
                title: Text(
                  "Contacts",
                  style: TextStyle(
                      fontSize: _labelFontSize,
                      color: (_page == 2)
                          ? UniversalVariables.lightBlueColor
                          : Colors.grey),
                ),
              ),
            ],
            onTap: navigationTapped,
          ),
        ),
      ),
    );
  }
}