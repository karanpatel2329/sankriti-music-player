import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sanskrit_music_player/pages/factList.dart';
import 'package:sanskrit_music_player/pages/player.dart';
import 'package:sanskrit_music_player/pages/popularList.dart';

import '../constant.dart';
import 'latestList.dart';

class MainPage extends StatefulWidget {

  BuildContext context;
  MainPage({required this.context});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>  with AutomaticKeepAliveClientMixin {
  String name='';
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      name=firebaseAuth.currentUser!.displayName.toString();
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(color: bgColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.sp,
            ),
            Text("Welcome "+name+",", style: TextStyle(
                color: primaryColor,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600),),
            SizedBox(
              height: 20.sp,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Lastest",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LastestSongList()));
                    },
                    child: Text(
                      "View All",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400),
                    ))
              ],
            ),
            Container(
              height: 200.h,
              margin: EdgeInsets.symmetric(vertical: 10.sp),
              child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('songs')
                      .limit(5)
                      .orderBy('uploadAt', descending: true)
                      .get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          List<QueryDocumentSnapshot<Object?>>? songList =snapshot.data?.docs;
                          QueryDocumentSnapshot<Object?>? data =
                          snapshot.data?.docs[index];

                          return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Player(song: songList,index: index,)));
                            },
                            child: Container(
                              height: 160.h,
                              width: 160.w,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(14.sp)),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 150.h,
                                    width: 150.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.sp)),
                                        image: DecorationImage(
                                            image:
                                            NetworkImage(data?.get('image')),
                                            fit: BoxFit.cover)),
                                  ),
                                  Text(
                                    data?.get('songName'),
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    data?.get('singerName'),
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data?.docs.length,
                      );
                    }
                    return Text("Loading");
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PopularSongList()));
                      print("Ss");
                    },
                    child: Text(
                      "View All",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400),
                    )),
              ],
            ),
            Container(
                height: 200.h,
                margin: EdgeInsets.symmetric(vertical: 10.sp),
                child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('songs')
                        .limit(15)
                        .get(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState==ConnectionState.done) {

                        return ListView.builder(
                          itemBuilder: (context, index) {
                            List<QueryDocumentSnapshot<Object?>>? songList =snapshot.data?.docs;
                            QueryDocumentSnapshot<Object?>? data =
                            snapshot.data?.docs[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Player(song: songList,index: index,)));
                              },
                              child: Container(
                                height: 160.h,
                                width: 160.w,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(14.sp)),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 150.h,
                                      width: 150.w,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(14.sp)),
                                          image: DecorationImage(
                                              image: NetworkImage(data?.get('image')),
                                              fit: BoxFit.cover)),
                                    ),
                                    Text(
                                      data?.get('songName'),
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      data?.get('singerName'),
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data?.docs.length,
                        );
                      }
                      print(snapshot.data);
                      return Text("Loading");
                    })),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Amazing Facts",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>FactList()));
                  },
                  child: Text(
                    "View All",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),


            Container(
              height: 200.h,
              margin: EdgeInsets.symmetric(vertical: 10.sp),
              child:FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('facts')
                      .get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
                            height: 120.h,
                            width: 260.w,
                            margin: EdgeInsets.all(6.sp),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(14.sp)),
                            ),
                            child:Container(
                              height: 120.h,
                              width: 260.w,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(14.sp)),
                                  image: DecorationImage(
                                      image: NetworkImage(snapshot.data?.docs[index].get('link')),
                                      fit: BoxFit.cover)),
                            ),
                          );
                        },
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data?.docs.length,
                      );
                    }
                    return Container();
                  })
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}