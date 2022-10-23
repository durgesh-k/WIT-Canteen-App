import 'package:animated_check/animated_check.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wit_canteen_app/globals.dart';
import 'package:wit_canteen_app/orderItem.dart';
import 'package:wit_canteen_app/screens/home.dart';

class OrderSuccess extends StatefulWidget {
  const OrderSuccess({Key? key}) : super(key: key);
  @override
  State<OrderSuccess> createState() => _OrderSuccessState();
}

class _OrderSuccessState extends State<OrderSuccess>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    AnimationController? _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    Animation<double>? _animation = new Tween<double>(begin: 0, end: 1).animate(
        new CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOutCirc));

    /*@override
    void initState() {
      super.initState();

      _animationController =
          AnimationController(vsync: this, duration: Duration(seconds: 1));

      _animation = new Tween<double>(begin: 0, end: 1).animate(
          new CurvedAnimation(
              parent: _animationController!, curve: Curves.easeInOutCirc));
    }*/

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          ' ',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        height: getHeight(context),
        width: getWidth(context),
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    height: getHeight(context) * 0.3,
                    width: getWidth(context) * 0.6,
                    child: Image.asset(
                      'assets/icons/order_placed.gif',
                      fit: BoxFit.contain,
                    ),
                    /*child: AnimatedCheck(
                    color: color,
                    progress: _animation,
                    size: 200,
                  )*/
                  ),
                  SizedBox(
                    height: getHeight(context) * 0.06,
                  ),
                  Container(
                    width: 250,
                    child: Text(
                      'Your order is successfully done',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Bold',
                          fontSize: 34,
                          color: Colors.black.withOpacity(0.8)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 250,
                    child: Text(
                      "You can track your order in the 'orders' section",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Medium',
                          fontSize: 20,
                          color: Colors.black.withOpacity(0.2)),
                    ),
                  ),
                ],
              ),
              /*Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Carts')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('Items')
                        .snapshots(),
                    builder: ((BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();
                      if (snapshot.data!.docs.length == 0)
                        return Container(
                            height: getHeight(context) * 0.4,
                            child: Center(
                                child: Text(
                              'No items',
                              style: TextStyle(
                                  fontFamily: 'SemiBold',
                                  fontSize: 30,
                                  color: Colors.grey.shade200),
                            )));
                      return Container(
                        height: getHeight(context) * 0.4,
                        width: getWidth(context) * 0.6,
                        child: Center(
                          child: SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (ctx, i) {
                                Map<String, dynamic> map =
                                    snapshot.data!.docs[i].data()
                                        as Map<String, dynamic>;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0, vertical: 2),
                                  child: OrderSuccessItem(
                                      map['product'],
                                      map['price'].toString(),
                                      map['image'],
                                      snapshot.data!.docs[i].id,
                                      map['quantity']),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.bounceInOut,
                              type: PageTransitionType.rightToLeft,
                              child: Home()),
                          (route) => false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(40)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 18),
                        child: Text(
                          '<  Back to home',
                          style: TextStyle(
                              fontFamily: 'SemiBold',
                              color: Colors.white,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              )*/
              SizedBox(
                height: getHeight(context) * 0.2,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.bounceInOut,
                          type: PageTransitionType.rightToLeft,
                          child: Home()),
                      (route) => false);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(40)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 18),
                    child: Text(
                      '<  Back to home',
                      style: TextStyle(
                          fontFamily: 'SemiBold',
                          color: Colors.white,
                          fontSize: 14),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
