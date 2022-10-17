import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wit_canteen_app/auth/login.dart';
import 'package:wit_canteen_app/cart.dart';
import 'package:wit_canteen_app/globals.dart';
import 'package:wit_canteen_app/onboard/onboarding.dart';
import 'package:wit_canteen_app/profile.dart';
import 'package:wit_canteen_app/screens/home.dart';

class Authenticate extends StatelessWidget {
  const Authenticate({Key? key}) : super(key: key);

  void getOpen() async {
    var isOpen =
        await FirebaseFirestore.instance.collection('Canteen').doc('0').get();
    open = isOpen['open'];
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      getOpen();
      return Home();
    } else {
      return OnBoarding();
    }
  }
}
