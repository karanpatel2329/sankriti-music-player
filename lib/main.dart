import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sanskrit_music_player/constant.dart';
import 'package:sanskrit_music_player/pages/homePage.dart';
import 'package:sanskrit_music_player/pages/latestList.dart';
import 'package:sanskrit_music_player/pages/loginPage.dart';
import 'package:sanskrit_music_player/pages/player.dart';
import 'package:sanskrit_music_player/pages/popularList.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin=true;
  Future<void> getLogin()async{
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    print(firebaseAuth.currentUser);
    //sleep(Duration(milliseconds: 500));
    if(firebaseAuth.currentUser != null){
      isLogin=true;
      print('USER THERE');
    }else{
      isLogin=false;
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
      print("No User");
    }
  }
  @override
  void initState() {
    getLogin();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:HomePage());
  }
}

