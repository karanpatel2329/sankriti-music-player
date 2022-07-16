import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sanskrit_music_player/constant.dart';
import 'package:sanskrit_music_player/pages/homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  late User _firebaseUser;
  String _status = "";
  bool otp = false;
  late AuthCredential _phoneAuthCredential;
  late String _verificationId;
  late int _code;
  late bool isAvailable = false;
  bool otpSent = false;
  bool isLoading = false;
  bool isLogin =false;

  void _handleError(e) {
    var snackBar = SnackBar(content: Text(e.message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    print(e.message);
    setState(() {
      _status += e.message + '\n';
      isLoading = false;
    });
  }

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(this._phoneAuthCredential)
          .then((UserCredential authRes) async {
        _firebaseUser = authRes.user!;
        print(_firebaseUser.toString());
        await _firebaseUser.updateDisplayName(_nameController.text);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      }).catchError((e) => _handleError(e));
      setState(() {
        _status += 'Signed In\n';
      });
    } catch (e) {
      print("HERE");
      _handleError(e);
    }
  }

  Future<void> _submitPhoneNumber() async {
    setState(() {
      isLoading = true;
    });
    String phoneNumber = "+91 " + _phoneNumberController.text.toString().trim();
    print(phoneNumber);

    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');
      setState(() {
        _status += 'verificationCompleted\n';
      });
      this._phoneAuthCredential = phoneAuthCredential;
      print(phoneAuthCredential);
      print("***");
    }

    void verificationFailed(error) {
      print('verificationFailed');
      _handleError(error);
    }

    void codeSent(String verificationId, [int? code]) {
      print('codeSent');
      this._verificationId = verificationId;
      print(verificationId);
      this._code = code!;
      print(code.toString());
      setState(() {
        _status += 'Code Sent\n';
        otp = true;
        otpSent=true;
        isLoading = false;
      });
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
      setState(() {
        _status += 'codeAutoRetrievalTimeout\n';
      });
      print(verificationId);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(milliseconds: 10000),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }

  void _submitOTP() {
    String smsCode = _otpController.text.toString().trim();

    this._phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: this._verificationId, smsCode: smsCode);
    _login();
    _phoneNumberController.clear();
    _otpController.clear();
    _status = "";
    setState(() {
      otp = false;
      otpSent=false;
      isLoading = false;
    });
  }
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: height * 0.95,
            width: width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    "Sanskriti Music Player",
                    style: TextStyle(
                        color:primaryColor,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700),
                  ),
                  Expanded(
                    child: Lottie.asset('assets/animations/study.json'),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30.sp,
                          ),
                          Text(
                            "Welcome Back,",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 30.sp,
                          ),
                          TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {

                            },
                            validator: (value) {
                              // if (!mobileValid || !emailValid) {
                              //   return 'Enter Valid Mobile No. Or Email Id';
                              // }
                              return null;
                            },
                            style: TextStyle(
                                color: Colors.white),
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.sp),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                filled: true,
                                focusColor: Colors.green,
                                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                hintText: "Enter Name",
                                fillColor: const Color(0xff323644).withOpacity(1)),
                          ),
                          SizedBox(
                            height: 20.sp,
                          ),
                          TextFormField(
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {

                            },
                            validator: (value) {
                              // if (!mobileValid || !emailValid) {
                              //   return 'Enter Valid Mobile No. Or Email Id';
                              // }
                              return null;
                            },
                            style: TextStyle(
                                color: Colors.white),
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.sp),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                filled: true,
                                focusColor: Colors.green,
                                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                hintText: "Enter Mobile No. or Email Id",
                                fillColor: const Color(0xff323644).withOpacity(1)),
                          ),
                          SizedBox(
                            height: 20.sp,
                          ),
                         Visibility(child:  TextFormField(
                           controller: _otpController,
                           keyboardType: TextInputType.phone,
                           validator: (value) {
                             if (value!.isEmpty) {
                               return 'Enter OTP';
                             }
                             return null;
                           },
                           style: const TextStyle(color: Colors.white),
                           decoration: InputDecoration(
                               border: UnderlineInputBorder(
                                 borderRadius: BorderRadius.circular(10.sp),
                                 borderSide: BorderSide.none,
                               ),
                               prefixIcon: Icon(
                                 Icons.admin_panel_settings_rounded,
                                 color: Colors.white.withOpacity(0.5),
                               ),
                               filled: true,
                               focusColor: Colors.green,
                               hintStyle:
                               TextStyle(color: Colors.white.withOpacity(0.5)),
                               hintText: "Enter Your Otp",
                               fillColor: const Color(0xff323644).withOpacity(1)),
                         ),visible: otp,),
                          Visibility(
                            child: Center(
                              child: GestureDetector(
                                onTap: () async {
                                  print("D");
                                  if (_formKey.currentState!.validate()) {
                                    _submitPhoneNumber();
                                  }
                                },
                                child:isLoading?CircularProgressIndicator(): Container(
                                  width: width * 0.6,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.all(Radius.circular(20))),
                                  child: Center(
                                      child: false
                                          ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                          : Text(
                                        "Send OTP",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20.sp),
                                      )),
                                ),
                              ),
                            ),
                            visible: !otp,
                          ),
                          SizedBox(
                            height: 20.sp,
                          ),
                          Visibility(
                            child: Center(
                              child: GestureDetector(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _submitOTP();
                                  }
                                },
                                child:isLoading?CircularProgressIndicator(): Container(
                                  width: width * 0.6,
                                  height: 50.h,
                                  decoration: const BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.all(Radius.circular(20))),
                                  child: Center(
                                      child: Text(
                                        "Continue",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20.sp),
                                      )),
                                ),
                              ),
                            ),
                            visible: otpSent,
                          )
                        ],
                      ),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
