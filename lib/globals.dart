import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

double getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

//const color = Color(0xFFE8460A);
var color = Colors.orange.shade900;
bool googleloading = false;

TextEditingController name = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

void showToast(String? str) {
  Fluttertoast.showToast(
      msg: str!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey.shade100,
      textColor: Colors.black.withOpacity(0.9),
      fontSize: 16.0);
}
