
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sanskrit_music_player/pages/loginPage.dart';
import 'package:sanskrit_music_player/pages/mainPage.dart';

import '../constant.dart';
import 'about.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController = PageController();
  int _selectedIndex = 0;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    ScreenUtil.init(
      context,
      designSize: const Size(390, 844),
      minTextAdapt: true,
    );

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Sanskriti Music Player"),
            backgroundColor: bgColor,
            foregroundColor: primaryColor,
            centerTitle: true,
          actions: [
            PopupMenuButton(
              initialValue: 2,
              child: Center(
                  child: Icon(Icons.more_vert,)),
              itemBuilder: (context) {
                return List.generate(1, (index) {
                  return PopupMenuItem(
                    value: index,
                    child: GestureDetector(
                      onTap: (){
                        firebaseAuth.signOut();
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);
                      },
                      child: Text("Log Out"),
                    )
                  );
                });
              },
            ),
          ],
          ),

          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey,
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                _pageController.jumpToPage(index);
              });
            },
            backgroundColor: bgColor,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_outlined),
                label: 'About Sanskrit',
              ),
            ],
          ),
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: <Widget>[
              MainPage(context: context),
              AboutPage(context: context,)
            ],
          )),
    );
  }
}
