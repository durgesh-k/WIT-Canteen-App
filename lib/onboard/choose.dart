import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wit_canteen_app/auth/login.dart';
import 'package:wit_canteen_app/globals.dart';

class Choose extends StatefulWidget {
  const Choose({Key? key}) : super(key: key);

  @override
  State<Choose> createState() => _ChooseState();
}

class _ChooseState extends State<Choose> {
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
                    image: AssetImage('assets/onboard.jpg'))),
          ),
          Container(
            height: getHeight(context) * 0.4,
            width: getWidth(context),
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: getWidth(context) * 0.9,
                    child: Text(
                      'Are you a Teacher or a Student?',
                      style: TextStyle(
                          fontFamily: 'Bold',
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 30),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                          elevation: 0,
                          splashColor: Colors.black.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 2,
                                  color: Colors.black.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(100)),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                PageTransition(
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.bounceInOut,
                                    type: PageTransitionType.rightToLeft,
                                    child: Login()),
                                (route) => false);
                          },
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 0.0),
                          child: Container(
                            height: 50,
                            width: getWidth(context) * 0.38,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.transparent),
                            child: Center(
                              child: Text(
                                'Student',
                                style: TextStyle(
                                  fontFamily: 'Bold',
                                  color: Colors.black.withOpacity(0.6),
                                  //color: Colors.orange.shade50,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )),
                      MaterialButton(
                          elevation: 0,
                          splashColor: Colors.black.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 2,
                                  color: Colors.black.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(100)),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                PageTransition(
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.bounceInOut,
                                    type: PageTransitionType.rightToLeft,
                                    child: Choose()),
                                (route) => false);
                          },
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 0.0),
                          child: Container(
                            height: 50,
                            width: getWidth(context) * 0.38,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.transparent),
                            child: Center(
                              child: Text(
                                'Teacher',
                                style: TextStyle(
                                  fontFamily: 'Bold',
                                  color: Colors.black.withOpacity(0.6),
                                  //color: Colors.orange.shade50,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )),
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
