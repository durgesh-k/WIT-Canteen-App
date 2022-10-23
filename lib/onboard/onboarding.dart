import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wit_canteen_app/globals.dart';
import 'package:wit_canteen_app/onboard/choose.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
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
                    image: AssetImage('assets/images/idli.jpg'))),
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
            height: getHeight(context) * 0.4,
            width: getWidth(context),
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: getWidth(context) * 0.66,
                    child: Text(
                      'Now get your canteen orders on time',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Bold',
                          color: Colors.white.withOpacity(1),
                          fontSize: 30),
                    ),
                  ),
                  Container(
                    width: getWidth(context) * 0.7,
                    child: Text(
                      'Follow next steps to Login/Create Account to quickly manage orders',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'SemiBold',
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                      elevation: 0,
                      splashColor: Colors.black.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.bounceInOut,
                                type: PageTransitionType.rightToLeft,
                                child: Choose()));
                      },
                      color: color,
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.transparent),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28.0, vertical: 18),
                            child: Text(
                              'Get Started',
                              style: TextStyle(
                                  fontFamily: 'SemiBold',
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                          ))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
