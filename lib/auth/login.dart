import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wit_canteen_app/auth/sign_up.dart';
import 'package:wit_canteen_app/globals.dart';
import 'package:wit_canteen_app/onboard/choose.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.bounceInOut,
                                type: PageTransitionType.rightToLeft,
                                child: Choose()),
                            (route) => false);
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
                            child: Text(
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
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp()),
                              (route) => false);
                        },
                        child: Container(
                          height: 40,
                          child: Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontFamily: 'Medium', color: Colors.blue),
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
