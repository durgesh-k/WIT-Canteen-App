import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hotreloader/hotreloader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

double getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

String? userType;
String? processType;

//const color = Color(0xFFE8460A);
var color = Colors.orange.shade900;
var color2 = Colors.black.withOpacity(0.05);
bool googleloading = false;
bool isVerified = false;

bool open = true;

String? getClassandId = '';
String? initiatedOrder;

TimeOfDay selectedTime =
    TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 30)));
int count = 0;

TextEditingController name = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController unique = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController number = TextEditingController();

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
