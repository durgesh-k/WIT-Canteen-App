import 'dart:convert';
import 'dart:math';
import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:wit_canteen_app/auth/login.dart';
import 'package:wit_canteen_app/screens/order_failure.dart';
import 'package:wit_canteen_app/screens/order_success.dart';

import 'globals.dart';

Future<void> pay(BuildContext context, String amount, String cartId) async {
  String? orderId = Random().nextInt(1000).toString();
  await FirebaseFirestore.instance.collection('Orders').add({
    'time': FieldValue.serverTimestamp(),
    'uid': FirebaseAuth.instance.currentUser!.uid,
    'status': 'CREATED',
    'pickup_time': selectedTime.format(context),
    'total': amount
  });
  await FirebaseFirestore.instance
      .collection('Orders')
      .orderBy('time', descending: true)
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) => orderId = value.docs[0].id);

  num payableAmount = num.parse(amount);
  getAccessToken(payableAmount, orderId.toString()).then((tokenData) {
    Map<String, String> _params = {
      'stage': 'TEST',
      'orderAmount': amount,
      'orderId': '$orderId',
      'orderCurrency': 'INR',
      'customerName': 'XYZ',
      'customerPhone': '8446849303',
      'customerEmail': 'xyz@gmail.com',
      'tokenData': tokenData,
      'appId': '1733509887cbd3f118d5c96f4c053371',
    };
    CashfreePGSDK.doPayment(_params).then((value) async {
      print(value);
      if (value != null) {
        if (value['txStatus'] == 'SUCCESS') {
          /*ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Payment Success"),
            ),
          );*/
          await FirebaseFirestore.instance
              .collection('Orders')
              .doc(orderId.toString())
              .set({
            'time': FieldValue.serverTimestamp(),
            'uid': FirebaseAuth.instance.currentUser!.uid,
            'status': 'SUCCESS',
            'pickup_time': selectedTime.format(context),
            'total': amount
          });
          await FirebaseFirestore.instance
              .collection("Carts")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('Items')
              .get()
              .then((query) {
            query.docs.forEach((doc) {
              var promise = FirebaseFirestore.instance
                  .collection("Orders")
                  .doc(orderId.toString())
                  .collection('Items')
                  .add(doc.data());
              /*FirebaseFirestore.instance
                  .collection("Recommendations")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('Items')
                  .doc(doc.data()['product'])
                  .set({'index': FieldValue.increment(doc.data()['quantity'])});*/
            });
            /*Navigator.push(
                context,
                PageTransition(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.bounceInOut,
                    type: PageTransitionType.rightToLeft,
                    child: OrderSuccess()));*/
          });

          await FirebaseFirestore.instance
              .collection("Carts")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('Items')
              .get()
              .then((query) {
            query.docs.forEach((doc) {
              FirebaseFirestore.instance
                  .collection("Recommendations")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('Items')
                  .doc(doc.id)
                  .update({
                'index': FieldValue.increment(doc.data()['quantity']),
              });
            });

            Navigator.pushReplacement(
                context,
                PageTransition(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.bounceInOut,
                    type: PageTransitionType.rightToLeft,
                    child: OrderFailure()));
          });

          await FirebaseFirestore.instance
              .collection('Carts')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('Items')
              .get()
              .then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
          });
          await FirebaseFirestore.instance
              .collection('Carts')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('Sum')
              .doc('0')
              .set({'sum': 0, 'quantity': 0});

          /*await FirebaseFirestore.instance
              .collection("Carts")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .delete();*/
        } else {
          /*ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Payment Failed"),
            ),
          );*/
          Navigator.push(
              context,
              PageTransition(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.bounceInOut,
                  type: PageTransitionType.rightToLeft,
                  child: OrderFailure()));
        }
      }
    });
  });
}

Future<String> getAccessToken(num amount, String orderId) async {
  print('1');
  var res = await http.post(
    Uri.https("test.cashfree.com", "api/v2/cftoken/order"),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'x-client-id': "1733509887cbd3f118d5c96f4c053371",
      'x-client-secret': "7c5b6a873fad7730fa3bceab3d39ef22cd99e632",
    },
    body: jsonEncode(
      {
        "orderId": '$orderId',
        "orderAmount": amount,
        "orderCurrency": "INR",
      },
    ),
  );
  if (res.statusCode == 200) {
    var jsonResponse = jsonDecode(res.body);
    if (jsonResponse['status'] == 'OK') {
      return jsonResponse['cftoken'];
    }
  }
  return '';
}

Future<String> cancelOrder(num amount, String orderId) async {
  print('started');
  var res = await http.post(
    Uri.parse("https://test.cashfree.com/api/v1/order/refund"),
    headers: <String, String>{
      'Content-Type': 'application/json',
      /*'x-client-id': "1733509887cbd3f118d5c96f4c053371",
      'x-client-secret': "7c5b6a873fad7730fa3bceab3d39ef22cd99e632",
      'Accept': "application/json",
      'x-api-version': "2022-01-01"*/
    },
    body: jsonEncode(
      {
        'appId': '1733509887cbd3f118d5c96f4c053371',
        'secretKey': '7c5b6a873fad7730fa3bceab3d39ef22cd99e632',
        "referenceId": '${orderId}',
        "refundAmount": amount,
        "refundNote": "refund for order k0v-vK1jv34"
      },
    ),
  );
  print(res.statusCode);
  if (res.statusCode == 200) {
    var jsonResponse = jsonDecode(res.body);
    if (jsonResponse['status'] == 'OK') {
      print(jsonResponse);
    }
    await FirebaseFirestore.instance
        .collection("Orders")
        .doc(orderId)
        .update({'status': 'CANCELED'});
  }
  print('ended');
  return '';
}
