import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sanskrit_music_player/constant.dart';
import 'package:sanskrit_music_player/pages/player.dart';

class LastestSongList extends StatefulWidget {
  const LastestSongList({Key? key}) : super(key: key);

  @override
  State<LastestSongList> createState() => _LastestSongListState();
}

class _LastestSongListState extends State<LastestSongList> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ScreenUtil.init(
      context,
      designSize: const Size(390, 844),
      minTextAdapt: true,
    );

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Lastest Songs",style: TextStyle(color: primaryColor),),
        centerTitle: true,
        backgroundColor: bgColor,
        foregroundColor: primaryColor,
      ),
      body: Container(
        margin: EdgeInsets.all(8.sp),
        height: height,
        width: width,
        child:FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('songs')
                .orderBy('uploadAt', descending: true)
                .get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(itemBuilder: (context, index) {
                  List<QueryDocumentSnapshot<Object?>>? songList =snapshot.data?.docs;
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Player(song: songList,index: index,)));
                    },
                    child: Container(
                      margin: EdgeInsets.all(5.sp),
                      width: 390.w,
                      height: 60.h,
                      child: Row(
                        children: [
                          Container(
                            height: 60.sp,
                            width: 60.sp,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(14.sp)),
                                image: DecorationImage(
                                  image: NetworkImage(snapshot.data!.docs[index].get('image')),
                                )
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data!.docs[index].get('songName'),style: TextStyle(fontSize: 18.sp,color: primaryColor),),
                              Text(snapshot.data!.docs[index].get('singerName'),style: TextStyle(fontSize: 16.sp,color: primaryColor,fontWeight: FontWeight.w300),)
                            ],
                          ),
                          Spacer(),
                          GestureDetector(onTap: (){
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.sp)),
                                  elevation: 6,
                                  child: Container(
                                      height: 150.h,
                                      width: 200.w,
                                      padding: EdgeInsets.symmetric(horizontal: 50.w),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Name: "+snapshot.data!.docs[index].get('songName'),style: TextStyle(fontSize: 17.sp),),
                                          Text("Singer: "+snapshot.data!.docs[index].get('singerName'),style: TextStyle(fontSize: 17.sp),),
                                        ],
                                      )
                                  ),
                                );
                              },
                            );
                          },child: Icon(Icons.more_vert,color: primaryColor,))
                        ],
                      ),
                    ),
                  );
                },
                  itemCount: snapshot.data!.docs.length,
                );
            }
              return Container();
            })

      )
    );
  }
}
