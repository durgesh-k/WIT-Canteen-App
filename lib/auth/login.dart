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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: getHeight(context),
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
            height: getHeight(context),
            width: getWidth(context),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.6),
                ])),
          ),
          Container(
            height: getHeight(context) * 0.46,
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
                          color: Colors.white,
                          fontSize: 30),
                    ),
                  ),
                  Container(
                    //width: getWidth(context) * 0.7,
                    child: Text(
                      'Login to quickly place orders',
                      style: TextStyle(
                          fontFamily: 'Regular',
                          color: Colors.white.withOpacity(0.5),
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
                            color: Colors.white.withOpacity(0.5)),
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*Container(
                        height: 1,
                        width: getWidth(context) * 0.1,
                        color: Colors.black.withOpacity(0.2),
                      ),*/
                      SizedBox(width: 30),
                      Text(
                        'or',
                        style: TextStyle(
                            fontFamily: 'SemiBold',
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.5)),
                      ),
                      SizedBox(width: 30),
                      /*Container(
                        height: 1,
                        width: getWidth(context) * 0.1,
                        color: Colors.black.withOpacity(0.2),
                      )*/
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      _showModalBottomSheetforNumber(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(40),
                        /*border: Border.all(
                              color: Colors.black.withOpacity(0.4), width: 2)*/
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 12),
                        child: Text(
                          'Use another phone number',
                          style: TextStyle(
                              fontFamily: 'SemiBold',
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

_showModalBottomSheetforNumber(context) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          double opacity = 0.0;
          double numberOpacity = 0.0;
          String msg = '';
          bool? loading = false;

          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              //height: getHeight(context) * 0.8,
              width: getWidth(context),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 1),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Icon(
                              Icons.close,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: getWidth(context) * 0.5,
                      child: Text(
                        'Enter another phone number',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Bold',
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 30),
                    Form(
                      key: numberkey,
                      child: TextFormField(
                        controller: number,
                        keyboardType: TextInputType.number,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            setState(() {
                              opacity = 1.0;
                              numberOpacity = 1.0;
                              msg = 'Phone number cannot be empty';
                            });
                            return null;
                            //return '\u26A0 First Name cannot be empty';
                          } else if (value.length < 10) {
                            setState(() {
                              opacity = 1.0;
                              numberOpacity = 1.0;
                              msg = 'Name must be at least 2 characters long';
                            });
                            return null;
                            //return '\u26A0 First Name must be at least 2 characters long';
                          }
                          setState(() {
                            numberOpacity = 0.0;
                            //opacity = 0.0;
                          });
                          return null;
                        },
                        style: const TextStyle(
                          fontFamily: "SemiBold",
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          focusColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100.0),
                            borderSide: BorderSide(
                                width: 0.0, color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(
                                width: 0.0, color: Colors.grey.shade50),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(
                                width: 0.0, color: Colors.grey.shade50),
                          ),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.05),
                          prefixIcon: Icon(
                            Icons.error,
                            size: 15,
                            color: Colors.red.withOpacity(numberOpacity),
                          ),
                          //labelText: "Email",
                          hintText: 'Phone number',
                          hintStyle: TextStyle(
                            fontFamily: "SemiBold",
                            fontSize: 14, //16,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    AnimatedOpacity(
                      opacity: opacity,
                      duration: Duration(milliseconds: 300),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 10,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Container(
                            width: getWidth(context) * 0.8,
                            child: Text(
                              msg,
                              style: const TextStyle(
                                  color: Colors.red, fontFamily: 'Regular'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    MaterialButton(
                        elevation: 0,
                        splashColor: Colors.black.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        onPressed: () async {
                          if (numberkey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: '+91 ${number.text}',
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
                                          phone: '+91 ${number.text}',
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
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        });
      });
}
