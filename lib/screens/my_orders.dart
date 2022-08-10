import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wit_canteen_app/globals.dart';
import 'package:wit_canteen_app/orderItem.dart';
import 'package:wit_canteen_app/order_backend.dart';
import 'package:wit_canteen_app/screens/home.dart';
import 'package:intl/intl.dart';

class OrderView extends StatefulWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          title: Text(
            'My Orders',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Bold',
                color: Colors.black.withOpacity(1),
                fontSize: 28),
          ),
          //centerTitle: true,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('time', descending: true)
            //.where('status', isEqualTo: 'SUCCESS')
            .snapshots(),
        builder:
            ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) {
              Map<String, dynamic> map =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              var id = snapshot.data!.docs[index].id;

              return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Orders')
                      .doc(snapshot.data!.docs[index].id)
                      .collection('Items')
                      .snapshots(),
                  builder: (context, snapshots) {
                    if (!snapshots.hasData) return const SizedBox.shrink();
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: Colors.black.withOpacity(0.03),
                                width: 2)),
                        //color: Colors.grey.shade100.withOpacity(0.5),
                        //borderRadius: BorderRadius.circular(36)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Order ',
                                      style: TextStyle(
                                          fontFamily: 'SemiBold',
                                          color: Colors.black,
                                          fontSize: 28),
                                    ),
                                    Text(
                                      ' #${snapshot.data!.docs[index].id.substring(0, 6)}',
                                      style: TextStyle(
                                          fontFamily: 'SemiBold',
                                          color: Colors.black.withOpacity(0.3),
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                /*Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: color2.withOpacity(0.06),
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 26,
                                          width: 26,
                                          child: Image.asset(
                                              'assets/images/frying.png'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 8),
                                          child: Text(
                                            snapshot.data!.docs[index]
                                                        ['status'] ==
                                                    'SUCCESS'
                                                ? 'Cooking'
                                                : snapshot.data!.docs[index]
                                                            ['status'] ==
                                                        'READY'
                                                    ? 'Ready'
                                                    : snapshot.data!.docs[index]
                                                                ['status'] ==
                                                            'DELIVERED'
                                                        ? 'Delivered'
                                                        : '',
                                            style: TextStyle(
                                                fontFamily: 'SemiBold',
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                            Text(
                                DateFormat.yMMMd().add_jm().format(snapshot
                                    .data!.docs[index]['time']
                                    .toDate()),
                                style: TextStyle(
                                    fontFamily: 'SemiBold',
                                    color: Colors.black.withOpacity(0.3),
                                    fontSize: 16)),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 14.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color:
                                              Colors.black.withOpacity(0.04)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                snapshots.data!.docs.length,
                                            itemBuilder: (ctx, i) {
                                              Map<String, dynamic> map2 =
                                                  snapshots.data!.docs[i].data()
                                                      as Map<String, dynamic>;

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0.0),
                                                child: OrderSuccessItem(
                                                    map2['product'],
                                                    map2['price'].toString(),
                                                    map2['image'],
                                                    snapshots.data!.docs[i].id,
                                                    map2['quantity']),
                                              );
                                            }),
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '₹ 30',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'SemiBold'),
                                    ),
                                    Text(
                                      '2 Items',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'SemiBold'),
                                    ),
                                    Text(
                                      'Cooking',
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 16,
                                          fontFamily: 'SemiBold'),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    snapshot.data!.docs[index]['status'] ==
                                            'SUCCESS'
                                        ? InkWell(
                                            onTap: () {
                                              cancelOrder(
                                                  120,
                                                  snapshot
                                                      .data!.docs[index].id);
                                            },
                                            child: Container(
                                              height: getHeight(context) * 0.05,
                                              width: getWidth(context) * 0.3,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(80),
                                                color: Colors.red,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontFamily: 'SemiBold'),
                                                ),
                                              ),
                                            ),
                                          )
                                        : snapshot.data!.docs[index]
                                                    ['status'] ==
                                                'DELIVERED'
                                            ? InkWell(
                                                onTap: () {
                                                  cancelOrder(
                                                      120,
                                                      snapshot.data!.docs[index]
                                                          .id);
                                                },
                                                child: Container(
                                                  height:
                                                      getHeight(context) * 0.05,
                                                  width:
                                                      getWidth(context) * 0.3,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80),
                                                    color: Colors.green,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '✔ Delivered',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'SemiBold'),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container()
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  /*Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('By :',
                                              style: TextStyle(
                                                  fontFamily: 'SemiBold',
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                  fontSize: 18)),
                                          SizedBox(
                                            width: 7,
                                          ),
                                          Text(
                                              FirebaseAuth.instance.currentUser!
                                                  .displayName!,
                                              style: TextStyle(
                                                  fontFamily: 'SemiBold',
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  fontSize: 18)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('On :',
                                              style: TextStyle(
                                                  fontFamily: 'SemiBold',
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                  fontSize: 18)),
                                          SizedBox(
                                            width: 7,
                                          ),
                                          Text(
                                              DateFormat.yMMMd()
                                                  .add_jm()
                                                  .format(snapshot
                                                      .data!.docs[index]['time']
                                                      .toDate()),
                                              style: TextStyle(
                                                  fontFamily: 'SemiBold',
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  fontSize: 18)),
                                        ],
                                      ),
                                    ],
                                  ),*/
                                  SizedBox(
                                    width: 20,
                                  ),
                                  /*snapshot.data!.docs[index]['status'] ==
                                          'SUCCESS'
                                      ? InkWell(
                                          onTap: () {
                                            cancelOrder(120,
                                                snapshot.data!.docs[index].id);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(80),
                                              color: Colors.red,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24.0,
                                                      vertical: 14),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily: 'SemiBold'),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container()*/
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
          );
        }),
      ),
    );
  }
}

class OrderViewCard extends StatefulWidget {
  const OrderViewCard({Key? key}) : super(key: key);

  @override
  State<OrderViewCard> createState() => _OrderViewCardState();
}

class _OrderViewCardState extends State<OrderViewCard> {
  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'Thanks for ordering!',
                    style: TextStyle(
                        fontFamily: 'Bold',
                        fontSize: 34,
                        color: Colors.black.withOpacity(0.8)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "We'll keep your order ready",
                    style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 20,
                        color: Colors.black.withOpacity(0.2)),
                  ),
                ],
              ),
              Column(
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
                        width: getWidth(context),
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (ctx, i) {
                              Map<String, dynamic> map = snapshot.data!.docs[i]
                                  .data() as Map<String, dynamic>;

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
                      );
                    }),
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
