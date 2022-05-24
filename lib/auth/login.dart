import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_number_picker/mobile_number_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wit_canteen_app/auth/sign_up.dart';
import 'package:wit_canteen_app/auth/verify_phone.dart';
import 'package:wit_canteen_app/components.dart';
import 'package:wit_canteen_app/globals.dart';
import 'package:wit_canteen_app/onboard/choose.dart';
import 'package:wit_canteen_app/screens/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  MobileNumberPicker mobileNumber = MobileNumberPicker();
  MobileNumber mobileNumberObject = MobileNumber();
  bool? loading = false;
  bool? loading2 = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    mobileNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: getHeight(context) * 0.6,
            width: getWidth(context),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.srcOver),
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/chai2.jpg'))),
          ),
          Container(
            height: getHeight(context) * 0.4,
            width: getWidth(context),
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    //width: getWidth(context) * 0.76,
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontFamily: 'Bold',
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 30),
                    ),
                  ),
                  Container(
                    //width: getWidth(context) * 0.7,
                    child: Text(
                      'Login to quickly place orders',
                      style: TextStyle(
                          fontFamily: 'Regular',
                          color: Colors.black.withOpacity(0.2),
                          fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: getHeight(context) * 0.04,
                  ),
                  MaterialButton(
                      elevation: 0,
                      splashColor: Colors.black.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      onPressed: () {
                        WidgetsBinding.instance!.addPostFrameCallback(
                            (timeStamp) => mobileNumber.mobileNumber());
                        mobileNumber.getMobileNumberStream
                            .listen((MobileNumber? event) async {
                          if (event?.states ==
                              PhoneNumberStates.PhoneNumberSelected) {
                            setState(() {
                              mobileNumberObject = event!;
                              loading = true;
                              processType = 'login';
                            });

                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber:
                                  '+91 ${mobileNumberObject.phoneNumber.toString()}',
                              verificationCompleted:
                                  (PhoneAuthCredential credential) async {},
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {},
                              codeSent: (String verificationId,
                                  int? forceResendingToken) {
                                showToast('OTP sent');
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.bounceInOut,
                                        type: PageTransitionType.rightToLeft,
                                        child: VerifyPhone(
                                          verificationId: verificationId,
                                          phone:
                                              '+91 ${mobileNumberObject.phoneNumber.toString()}',
                                        )));
                              },
                              verificationFailed:
                                  (FirebaseAuthException error) {
                                setState(() {
                                  loading = false;
                                });
                                showToast(
                                    'Error Verifying\nPlease check your Mobile Number and try again');
                              },
                            );
                          }
                        });
                      },
                      color: color,
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: Container(
                        height: 50,
                        width: getWidth(context),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.transparent),
                        child: Center(
                            child: loading!
                                ? CircularProgress(
                                    size: 20,
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Next',
                                    style: TextStyle(
                                      fontFamily: 'Bold',
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  )),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                            fontFamily: 'Medium',
                            color: Colors.black.withOpacity(0.5)),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            processType = 'signup';
                          });

                          WidgetsBinding.instance!.addPostFrameCallback(
                              (timeStamp) => mobileNumber.mobileNumber());
                          mobileNumber.getMobileNumberStream
                              .listen((MobileNumber? event) async {
                            if (event?.states ==
                                PhoneNumberStates.PhoneNumberSelected) {
                              setState(() {
                                mobileNumberObject = event!;
                                loading2 = true;
                              });
                              /*var userDoc = await FirebaseFirestore.instance
                                  .collection("Students")
                                  .where('phone',
                                      isEqualTo: mobileNumberObject.phoneNumber
                                          .toString())
                                  .get();*/
                              //if (userDoc.docs.length == 1) {
                              /*showToast('Account already exist');
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  PageTransition(
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.bounceInOut,
                                      type: PageTransitionType.rightToLeft,
                                      child: Home()),
                                  (route) => false);*/
                              //} else {
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber:
                                    '+91 ${mobileNumberObject.phoneNumber.toString()}',
                                verificationCompleted:
                                    (PhoneAuthCredential credential) async {},
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {},
                                codeSent: (String verificationId,
                                    int? forceResendingToken) {
                                  showToast('OTP sent');
                                  setState(() {
                                    loading = false;
                                    loading2 = false;
                                  });
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.bounceInOut,
                                          type: PageTransitionType.rightToLeft,
                                          child: VerifyPhone(
                                            verificationId: verificationId,
                                            phone:
                                                '+91 ${mobileNumberObject.phoneNumber.toString()}',
                                          )));
                                },
                                verificationFailed:
                                    (FirebaseAuthException error) {
                                  setState(() {
                                    loading = false;
                                    loading2 = false;
                                  });
                                  showToast(
                                      'Error Verifying\nPlease check your Mobile Number and try again');
                                },
                              );
                              //}
                            }
                          });
                          /*Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp()),
                              (route) => false);*/
                        },
                        child: Container(
                          height: 40,
                          child: Center(
                            child: loading2!
                                ? CircularProgress(
                                    size: 14,
                                    color: Colors.blue,
                                  )
                                : Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        fontFamily: 'Medium',
                                        color: Colors.blue),
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
