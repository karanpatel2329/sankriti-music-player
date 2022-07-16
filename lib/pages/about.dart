import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant.dart';

class AboutPage extends StatefulWidget {
  BuildContext context;
  AboutPage({required this.context});
  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with AutomaticKeepAliveClientMixin  {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ScreenUtil.init(
      context,
      designSize: const Size(390, 844),
      minTextAdapt: true,
    );

    return SingleChildScrollView(
        child: Container(
          height: height,
        width: width,
        padding: EdgeInsets.all(8.sp),
    decoration: BoxDecoration(
    color:bgColor
    ),
    child: Column(
      children: [
        Image(
          image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEH8IZRoDPZfzfQcN_dJJqnl6I7k30D9ddcg&usqp=CAU"),
          width: width*0.7,
          height: 200.h,
        ),
        SizedBox(height: 20.sp,),
        Text("Sanskrit is a classical language of South Asia that belongs to the Indo-Aryan branch of the Indo-European languages. It arose in South Asia after its predecessor languages had diffused there from the northwest in the late Bronze Age.",style: TextStyle(color: primaryColor,fontSize: 17.sp),),
        SizedBox(height: 20.sp,),
        Text("Sanskrit is a classical language of South Asia that belongs to the Indo-Aryan branch of the Indo-European languages. It arose in South Asia after its predecessor languages had diffused there from the northwest in the late Bronze Age.",style: TextStyle(color: primaryColor,fontSize: 17.sp),),
        SizedBox(height: 20.sp,),
        Text("Sanskrit is a classical language of South Asia that belongs to the Indo-Aryan branch of the Indo-European languages. It arose in South Asia after its predecessor languages had diffused there from the northwest in the late Bronze Age.",style: TextStyle(color: primaryColor,fontSize: 17.sp),),
        SizedBox(height: 20.sp,),
        Text("Sanskrit is a classical language of South Asia that belongs to the Indo-Aryan branch of the Indo-European languages. It arose in South Asia after its predecessor languages had diffused there from the northwest in the late Bronze Age.",style: TextStyle(color: primaryColor,fontSize: 17.sp),),
        SizedBox(height: 20.sp,),
        Text("Sanskrit is a classical language of South Asia that belongs to the Indo-Aryan branch of the Indo-European languages. It arose in South Asia after its predecessor languages had diffused there from the northwest in the late Bronze Age.",style: TextStyle(color: primaryColor,fontSize: 17.sp),),
      ],

    )));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
