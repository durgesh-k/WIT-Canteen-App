import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wit_canteen_app/auth/id_upload.dart';
import 'package:wit_canteen_app/components.dart';
import 'package:wit_canteen_app/globals.dart';
import 'package:wit_canteen_app/screens/home.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  Timer? timer;

  void checkVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isVerified) {
      showToast('Email Verified');
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     PageTransition(
      //         duration: Duration(milliseconds: 200),
      //         curve: Curves.bounceInOut,
      //         type: PageTransitionType.rightToLeft,
      //         child: IDupload()),
      //     (route) => false);
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              duration: Duration(milliseconds: 200),
              curve: Curves.bounceInOut,
              type: PageTransitionType.rightToLeft,
              child: Home()),
          (route) => false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 3), (_) => checkVerified());
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: getHeight(context) * 0.26,
          ),
          Container(
            height: getHeight(context) * 0.3,
            width: getWidth(context) * 0.5,
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/icons/email.gif'))),
          ),
          Container(
            height: getHeight(context) * 0.2,
            width: getWidth(context),
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: getWidth(context) * 0.6,
                    child: Text(
                      'Please check your email for verification link',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Bold',
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 26),
                    ),
                  ),
                  Container(
                    width: getWidth(context) * 0.6,
                    child: Text(
                      "Don't forget your spam",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'SemiBold',
                          color: Colors.black.withOpacity(0.2),
                          fontSize: 22),
                    ),
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
