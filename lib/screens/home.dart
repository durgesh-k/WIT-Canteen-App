import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wit_canteen_app/globals.dart';
import 'package:wit_canteen_app/menuGrid.dart';
import 'package:wit_canteen_app/menuitem.dart';
import 'package:wit_canteen_app/order.dart';
import 'package:wit_canteen_app/profile.dart';
import 'package:wit_canteen_app/screens/order_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  Animation? notiHeight;
  Animation? notiWidth;
  AnimationController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    notiHeight = Tween<double>(begin: 0.0, end: 80.0).animate(controller!);
    notiWidth = Tween<double>(begin: 0.0, end: 300).animate(controller!);
    controller!.addListener(() {
      setState(() {});
    });
    controller!.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.bounceInOut,
                              type: PageTransitionType.leftToRight,
                              child: ProfilePage()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: color2,
                            borderRadius: BorderRadius.circular(80)),
                        child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Icon(Iconsax.menu) //
                            ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DELIVER TO',
                          style: TextStyle(
                              letterSpacing: 1.2,
                              fontFamily: 'SemiBold',
                              color: color),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'WIT Canteen',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Medium',
                              color: Colors.black.withOpacity(0.6)),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.bounceInOut,
                              type: PageTransitionType.rightToLeft,
                              child: OrderView()),
                        );
                      },
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Orders')
                              .where('uid',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .orderBy('time', descending: true)
                              .where('status', isEqualTo: 'SUCCESS')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return Container();
                            if (snapshot.data!.docs.length >= 1) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: color2,
                                    borderRadius: BorderRadius.circular(80)),
                                child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Badge(
                                        elevation: 0,
                                        badgeColor: color,
                                        badgeContent: Text(
                                          snapshot.data!.docs.length.toString(),
                                          style: TextStyle(
                                              fontFamily: 'Medium',
                                              color: Colors.white),
                                        ),
                                        child: Icon(Iconsax.reserve)) //
                                    ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.bounceInOut,
                              type: PageTransitionType.rightToLeft,
                              child: OrderPage()),
                        );
                      },
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Carts')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('Items')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return Container();
                            if (!snapshot.hasError) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: color2,
                                    borderRadius: BorderRadius.circular(80)),
                                child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Badge(
                                        elevation: 0,
                                        badgeColor: color,
                                        badgeContent: Text(
                                          snapshot.data!.docs.length.toString(),
                                          style: TextStyle(
                                              fontFamily: 'Medium',
                                              color: Colors.white),
                                        ),
                                        child: Icon(Iconsax.shopping_cart)) //
                                    ),
                              );
                            } else {
                              return Container(
                                decoration: BoxDecoration(
                                    color: color2,
                                    borderRadius: BorderRadius.circular(80)),
                                child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Badge(
                                        elevation: 0,
                                        badgeColor: color,
                                        badgeContent: Text(
                                          '0',
                                          style: TextStyle(
                                              fontFamily: 'Medium',
                                              color: Colors.white),
                                        ),
                                        child: Icon(Iconsax.shopping_cart)) //
                                    ),
                              );
                            }
                          }),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            /*Stack(
              children: [
                Container(
                  width: getWidth(context),
                  // color: Colors.red,
                  child: Text(
                    "Welcome!",
                    style: TextStyle(
                      fontFamily: 'SemiBold',
                      fontSize: 35,
                    ),
                  ),
                ),
                Container(
                  height: notiHeight!.value,
                  width: notiWidth!.value,
                  decoration: BoxDecoration(
                      color: color2, borderRadius: BorderRadius.circular(100)),
                ),
              ],
            ),*/
            /*SizedBox(
              height: 20,
            ),*/

            //Search box
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: getWidth(context)),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Search",
                  labelStyle: TextStyle(
                      fontFamily: 'SemiBold',
                      fontSize: 20,
                      color: Colors.grey.withOpacity(0.5),
                      fontWeight: FontWeight.w500),
                  prefixIcon: Icon(Iconsax.search_normal),
                  prefixIconColor: Colors.grey.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide.none,
                  ),
                  fillColor:
                      const Color.fromARGB(255, 224, 224, 224).withOpacity(0.3),
                  filled: true,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: getWidth(context),
                    // color: Colors.red,
                    child: Text(
                      "Offers",
                      style: TextStyle(
                        fontFamily: 'SemiBold',
                        fontSize: 32,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Offers')
                        .snapshots(),
                    builder: ((BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();
                      return Container(
                        height: 100,
                        child: ListView.builder(
                            primary: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, i) {
                              Map<String, dynamic> map = snapshot.data!.docs[i]
                                  .data() as Map<String, dynamic>;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: OfferItem(
                                  img: map['image'],
                                  condition: map['condition'],
                                  percent: map['percent'],
                                ),
                              );
                            }),
                      );
                    }),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: getWidth(context),
                    // color: Colors.red,
                    child: Text(
                      "Menu",
                      style: TextStyle(
                        fontFamily: 'SemiBold',
                        fontSize: 32,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(child: MenuGrid()),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Carts')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('Items')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          if (snapshot.data!.docs.length != 0) {
            return Container(
              height: 80,
              width: getWidth(context),
              color: color,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Carts')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('Sum')
                                .snapshots(),
                            builder: (context, snapshot2) {
                              if (!snapshot2.hasData) return Container();
                              return Text(
                                '₹ ${snapshot2.data!.docs[0]['sum'].toString()}',
                                style: TextStyle(
                                    fontFamily: 'SemiBold',
                                    color: Colors.white,
                                    fontSize: 36),
                              );
                            }),
                        Text(
                          '    ${snapshot.data!.docs.length} items',
                          style: TextStyle(
                              fontFamily: 'SemiBold',
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 20),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.bounceInOut,
                              type: PageTransitionType.rightToLeft,
                              child: OrderPage()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'View Cart',
                            style: TextStyle(
                                fontFamily: 'SemiBold',
                                color: color,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
