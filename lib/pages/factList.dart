import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant.dart';

class FactList extends StatefulWidget {
  const FactList({Key? key}) : super(key: key);

  @override
  State<FactList> createState() => _FactListState();
}

class _FactListState extends State<FactList> {
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
          title: Text("Facts",style: TextStyle(color: primaryColor),),
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
                    .collection('facts')
                    .get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          height: 170.h,
                          width: 260.w,
                          margin: EdgeInsets.all(6.sp),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(14.sp)),
                          ),
                          child:Container(
                            height: 170.h,
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
                      itemCount: snapshot.data?.docs.length,
                    );
                  }
                  return Container();
                })
        )
    );
  }
}
