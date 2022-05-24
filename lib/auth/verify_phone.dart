import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wit_canteen_app/auth/sign_up.dart';
import 'package:wit_canteen_app/components.dart';
import 'package:wit_canteen_app/globals.dart';
import 'package:wit_canteen_app/screens/home.dart';

class VerifyPhone extends StatefulWidget {
  final String? verificationId;
  String? phone;
  VerifyPhone({Key? key, this.phone, this.verificationId}) : super(key: key);

  @override
  State<VerifyPhone> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();
  String? _otp;
  bool? loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          height: getHeight(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: getHeight(context) * 0.1,
              ),
              Container(
                width: getWidth(context) * 0.76,
                child: Text(
                  'Verify OTP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Bold',
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 30),
                ),
              ),
              SizedBox(
                height: getHeight(context) * 0.02,
              ),
              Container(
                width: getWidth(context) * 0.7,
                child: Text(
                  'Please enter the OTP sent to ${widget.phone}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Regular',
                      color: Colors.black.withOpacity(0.2),
                      fontSize: 16),
                ),
              ),
              SizedBox(
                height: getHeight(context) * 0.1,
              ),
              Container(
                width: getWidth(context),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OtpInput(_fieldOne, true),
                      OtpInput(_fieldTwo, false),
                      OtpInput(_fieldThree, false),
                      OtpInput(_fieldFour, false),
                      OtpInput(_fieldFive, false),
                      OtpInput(_fieldSix, false)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: getHeight(context) * 0.35,
              ),
              MaterialButton(
                  elevation: 0,
                  splashColor: Colors.black.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                      _otp = _fieldOne.text +
                          _fieldTwo.text +
                          _fieldThree.text +
                          _fieldFour.text +
                          _fieldFive.text +
                          _fieldSix.text;
                    });
                    FirebaseAuth _auth = FirebaseAuth.instance;

                    try {
                      AuthCredential credential = PhoneAuthProvider.credential(
                          verificationId: widget.verificationId!,
                          smsCode: _otp!);

                      var result = await _auth.signInWithCredential(credential);

                      var user = result.user;
                      if (user != null) {
                        if (processType == 'signup') {
                          var userDoc = await FirebaseFirestore.instance
                              .collection("Students")
                              .where('phone',
                                  isEqualTo: widget.phone!.substring(4))
                              .get();
                          if (userDoc.docs.length == 1) {
                            showToast('Account already exist');
                            Navigator.pushAndRemoveUntil(
                                context,
                                PageTransition(
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.bounceInOut,
                                    type: PageTransitionType.rightToLeft,
                                    child: Home()),
                                (route) => false);
                          } else {
                            await FirebaseFirestore.instance
                                .collection('Students')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .set({
                              'class': null,
                              'enrollment': null,
                              'email': null,
                              'id': null,
                              'name': null,
                              'phone': null
                            });
                            await FirebaseFirestore.instance
                                .collection('Students')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({'phone': widget.phone!.substring(4)});
                            showToast('Phone Verified');
                            Navigator.push(
                              context,
                              PageTransition(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.bounceInOut,
                                  type: PageTransitionType.rightToLeft,
                                  child: SignUp()),
                            );
                          }
                        } else {
                          var userDoc = await FirebaseFirestore.instance
                              .collection("Students")
                              .where('phone',
                                  isEqualTo: widget.phone!.substring(4))
                              .get();
                          if (userDoc.docs.length == 1) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                PageTransition(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.bounceInOut,
                                    type: PageTransitionType.rightToLeft,
                                    child: Home()),
                                ((route) => false));
                          }
                        }
                        /*Navigator.push(
                          context,
                          PageTransition(
                              duration: Duration(milliseconds: 400),
                              curve: Curves.bounceInOut,
                              type: PageTransitionType.rightToLeft,
                              child: Home()),
                        );*/
                      } else {
                        setState(() {
                          loading = false;
                        });
                        showToast('Incorrect OTP\nPlease try again');
                      }
                    } catch (e) {
                      setState(() {
                        loading = false;
                      });
                      showToast('Error\nPlease try again');
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
            ],
          ),
        ),
      ),
    );
  }
}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: getWidth(context) * 0.13,
      child: Center(
        child: TextField(
          autofocus: autoFocus,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          controller: controller,
          maxLength: 1,
          cursorColor: Colors.orange,
          style: TextStyle(
            fontFamily: "SemiBold",
            fontSize: 32,
            color: Colors.black.withOpacity(0.8),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 0.0, color: Colors.grey.shade50),
            ),
            disabledBorder: InputBorder.none,
            counterText: '',
          ),
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
          },
        ),
      ),
    );
  }
}
