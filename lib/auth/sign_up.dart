import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wit_canteen_app/auth/auth_backend.dart';
import 'package:wit_canteen_app/auth/google_sign_in.dart';
import 'package:wit_canteen_app/auth/login.dart';
import 'package:wit_canteen_app/auth/verify_email.dart';
import 'package:wit_canteen_app/components.dart';
import 'package:wit_canteen_app/globals.dart';
import 'package:wit_canteen_app/screens/home.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscureText2 = true;
  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  double opacity = 0.0;
  double nameOpacity = 0.0;
  double emailOpacity = 0.0;
  double enrolOpacity = 0.0;
  String msg = '';
  String? _class;
  final signupkey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: signupkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: getHeight(context) * 0.1,
                ),
                const Text(
                  'Create new account',
                  style: TextStyle(
                      fontFamily: 'Bold', fontSize: 30, color: Colors.black),
                ),
                SizedBox(
                  height: getHeight(context) * 0.02,
                ),
                Text(
                  'Please fill in the details below to continue',
                  style: TextStyle(
                      fontFamily: 'Regular',
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.4)),
                ),
                SizedBox(
                  height: getHeight(context) * 0.1,
                ),
                TextFormField(
                  controller: name,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      setState(() {
                        opacity = 1.0;
                        nameOpacity = 1.0;
                        msg = 'Name cannot be empty';
                      });
                      return null;
                      //return '\u26A0 First Name cannot be empty';
                    } else if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                        .hasMatch(value)) {
                      setState(() {
                        opacity = 1.0;
                        nameOpacity = 1.0;
                        msg = 'Enter a valid Name';
                      });
                      return null;
                      //return '\u26A0 Enter valid First Name';
                    } else if (value.length < 2) {
                      setState(() {
                        opacity = 1.0;
                        nameOpacity = 1.0;
                        msg = 'Name must be at least 2 characters long';
                      });
                      return null;
                      //return '\u26A0 First Name must be at least 2 characters long';
                    }
                    setState(() {
                      nameOpacity = 0.0;
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
                      borderSide:
                          BorderSide(width: 0.0, color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide:
                          BorderSide(width: 0.0, color: Colors.grey.shade50),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide:
                          BorderSide(width: 0.0, color: Colors.grey.shade50),
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.05),
                    prefixIcon: Icon(
                      Icons.error,
                      size: 15,
                      color: Colors.red.withOpacity(nameOpacity),
                    ),
                    //labelText: "Email",
                    hintText: 'Name',
                    hintStyle: TextStyle(
                      fontFamily: "SemiBold",
                      fontSize: 14, //16,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                TextFormField(
                  controller: email,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      setState(() {
                        opacity = 1.0;
                        emailOpacity = 1.0;
                        msg = 'Email is required';
                      });
                      return null;
                      //return 'Email is required';
                    } else if (!RegExp(
                            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                        .hasMatch(value)) {
                      setState(() {
                        opacity = 1.0;
                        emailOpacity = 1.0;
                        msg = 'Please enter a valid Email Address';
                      });
                      return null;
                      //return 'Please enter a valid email Address';
                    }
                    setState(() {
                      emailOpacity = 0.0;
                      //opacity = 0.0;
                    });
                    return null;
                  },
                  inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                  style: const TextStyle(
                    fontFamily: "SemiBold",
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    focusColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide:
                          BorderSide(width: 0.0, color: Colors.grey.shade50),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(width: 10.0, color: Colors.grey.shade100),
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.05),
                    prefixIcon: Icon(
                      Icons.error,
                      size: 15,
                      color: Colors.red.withOpacity(emailOpacity),
                    ),
                    //labelText: "Email",
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      fontFamily: "SemiBold",
                      fontSize: 14, //16,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                /*TextFormField(
                  obscureText: _obscureText2,
                  controller: password,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      setState(() {
                        opacity = 1.0;
                        passOpacity = 1.0;
                        msg = 'Password is required';
                      });
                      return null;
                      //return 'Password is required';
                    } else if (!RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                        .hasMatch(value)) {
                      setState(() {
                        opacity = 1.0;
                        passOpacity = 1.0;
                        msg =
                            'Password must have atleast one Uppercase, one Lowercase, one special character, and one numeric value';
                      });
                      return null;
                      //return 'Please enter a valid password';
                    }
                    setState(() {
                      passOpacity = 0.0;
                      //opacity = 0.0;
                    });
                    return null;
                  },
                  inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                  style: const TextStyle(
                    fontFamily: "SemiBold",
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide:
                          BorderSide(width: 0.0, color: Colors.grey.shade50),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide:
                          BorderSide(width: 10.0, color: Colors.grey.shade100),
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.05),
                    prefixIcon: Icon(
                      Icons.error,
                      size: 15,
                      color: Colors.red.withOpacity(passOpacity),
                    ),
                    //labelText: "Password",
                    hintText: "Password",
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: GestureDetector(
                        child: Container(
                          height: 10,
                          width: 10,
                          child: SvgPicture.asset(
                            'assets/show.svg',
                            color: _obscureText2
                                ? Colors.black.withOpacity(0.2)
                                : color,
                          ),
                        ),
                        onTap: () {
                          _toggle2();
                        },
                      ),
                    ),
                    hintStyle: TextStyle(
                      fontFamily: "SemiBold",
                      fontSize: 14, //16,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),*/
                TextFormField(
                  controller: unique,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      setState(() {
                        opacity = 1.0;
                        enrolOpacity = 1.0;
                        msg = userType == 'teacher'
                            ? 'PAN no. is required'
                            : 'Enrollment no. is required';
                      });
                      return null;
                      //return 'Email is required';
                    }
                    setState(() {
                      enrolOpacity = 0.0;
                      //opacity = 0.0;
                    });
                    return null;
                  },
                  inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                  style: const TextStyle(
                    fontFamily: "SemiBold",
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    focusColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide:
                          BorderSide(width: 0.0, color: Colors.grey.shade50),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(width: 10.0, color: Colors.grey.shade100),
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.05),
                    prefixIcon: Icon(
                      Icons.error,
                      size: 15,
                      color: Colors.red.withOpacity(emailOpacity),
                    ),
                    //labelText: "Email",
                    hintText:
                        userType == 'teacher' ? 'Pan No.' : 'Enrollment No.',
                    hintStyle: TextStyle(
                      fontFamily: "SemiBold",
                      fontSize: 14, //16,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                userType == 'teacher'
                    ? Container(
                        height: 54,
                        width: getWidth(context),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(100)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: DropdownButton<String>(
                            value: _class,
                            icon: Container(),
                            underline: Container(),
                            borderRadius: BorderRadius.circular(20),
                            hint: Text(
                              'Choose Department ▼',
                              style: TextStyle(
                                fontFamily: "SemiBold",
                                fontSize: 14, //16,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ),
                            items: <String>[
                              'CSE',
                              'IT',
                              'ENTC',
                              'MECH',
                              'Office'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontFamily: "SemiBold",
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _class = value;
                              });
                            },
                          ),
                        ),
                      )
                    : Container(
                        height: 54,
                        width: getWidth(context),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(100)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: DropdownButton<String>(
                            value: _class,
                            icon: Container(),
                            underline: Container(),
                            borderRadius: BorderRadius.circular(20),
                            hint: Text(
                              'Choose Class ▼',
                              style: TextStyle(
                                fontFamily: "SemiBold",
                                fontSize: 14, //16,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ),
                            items: <String>[
                              'TY-CSE-A',
                              'TY-CSE-B',
                              'TY-IT',
                              'TY-ENTC-A',
                              'TY-ENTC-B'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontFamily: "SemiBold",
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _class = value;
                              });
                            },
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 10,
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
                  height: getHeight(context) * 0.12,
                ),
                MaterialButton(
                    elevation: 0,
                    splashColor: Colors.black.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    onPressed: () async {
                      if (_class == null) {
                        setState(() {
                          msg = 'Please choose you class';
                          opacity = 1.0;
                        });
                      } else {
                        try {
                          if (signupkey.currentState!.validate()) {
                            if (nameOpacity == 0.0 &&
                                emailOpacity == 0.0 &&
                                enrolOpacity == 0.0) {
                              setState(() {
                                opacity = 0.0;
                                loading = true;
                              });

                              await FirebaseAuth.instance.currentUser!
                                  .updateDisplayName(name.text);
                              await FirebaseAuth.instance.currentUser!
                                  .updateEmail(email.text);
                              if (FirebaseAuth.instance.currentUser != null) {
                                setState(() {
                                  loading = false;
                                });
                                await FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({
                                  'email': email.text,
                                  'name': name.text,
                                  'uniqueNumber': unique.text,
                                  'class': _class,
                                  'userType': userType
                                });
                                await FirebaseFirestore.instance
                                    .collection('Carts')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('Sum')
                                    .doc('0')
                                    .set({'sum': 0, 'quantity': 0});
                                await FirebaseFirestore.instance
                                    .collection("Menu")
                                    .get()
                                    .then((query) {
                                  query.docs.forEach((doc) {
                                    FirebaseFirestore.instance
                                        .collection("Recommendations")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .collection('Items')
                                        .doc(doc.id)
                                        .set({
                                      'product': doc.data()['product'],
                                      'image': doc.data()['image'],
                                      'price': doc.data()['price'],
                                      'index': 0,
                                    });
                                  });
                                });
                                print(FirebaseAuth
                                    .instance.currentUser!.displayName);
                                await FirebaseAuth.instance.currentUser!
                                    .sendEmailVerification();
                                setState(() {
                                  loading = false;
                                });
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    PageTransition(
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.bounceInOut,
                                        type: PageTransitionType.rightToLeft,
                                        child: VerifyEmail()),
                                    (route) => false);
                                showToast('Account Created');
                              }
                            } else {
                              setState(() {
                                loading = false;
                              });
                              showToast('Account Creation failed');
                            }
                          }
                          /*createAccount(email.text, 'Qwerty!123', 'Qwerty!123')
                              .then((user) async {});*/
                        } catch (e) {
                          showToast('Please check your details and try again');
                          setState(() {
                            loading = false;
                          });
                        }
                      }
                    },
                    color: color,
                    padding: EdgeInsets.symmetric(horizontal: 0.0),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.transparent),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          loading
                              ? const CircularProgress(
                                  size: 20,
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Sign up',
                                  style: TextStyle(
                                    fontFamily: 'Bold',
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                        ],
                      ),
                    )),
                /*const SizedBox(
                  height: 10,
                ),*/
                /* MaterialButton(
                    elevation: 0,
                    splashColor: Colors.black.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 2, color: Colors.black.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(100)),
                    onPressed: () {
                      try {
                        setState(() {
                          googleloading = true;
                        });
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);
                        provider.googleLogin(context);
                        print(provider);
                        setState(() {
                          googleloading = false;
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Spacer(),
                          SvgPicture.asset(
                            'assets/icons/google.svg',
                            height: 18,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          googleloading
                              ? CircularProgress(
                                  size: 20,
                                  color: Colors.black,
                                )
                              : Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                    fontFamily: 'Bold',
                                    color: Colors.black.withOpacity(0.6),
                                    //color: Colors.orange.shade50,
                                    fontSize: 16,
                                  ),
                                ),
                        ],
                      ),
                    )),*/
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Have an account?",
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
                          processType = 'login';
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.bounceInOut,
                                type: PageTransitionType.leftToRight,
                                child: Login()),
                            (route) => false);
                        /*Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                            (route) => false);*/
                      },
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Text(
                            'Sign In',
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
        ),
      )),
    );
  }
}
