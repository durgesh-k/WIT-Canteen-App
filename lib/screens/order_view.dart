import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wit_canteen_app/globals.dart';
import 'package:wit_canteen_app/orderItem.dart';
import 'package:wit_canteen_app/screens/home.dart';

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
      appBar: AppBar(
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('time', descending: true)
            .where('status', isEqualTo: 'SUCCESS')
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(36)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Order ',
                                    style: TextStyle(
                                        fontFamily: 'SemiBold',
                                        color: Colors.black,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    ' #${snapshot.data!.docs[index].id.substring(0, 6)}',
                                    style: TextStyle(
                                        fontFamily: 'Regular',
                                        color: Colors.black.withOpacity(0.3),
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshots.data!.docs.length,
                                  itemBuilder: (ctx, i) {
                                    Map<String, dynamic> map2 =
                                        snapshots.data!.docs[i].data()
                                            as Map<String, dynamic>;

                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: OrderSuccessItem(
                                          map2['product'],
                                          map2['price'].toString(),
                                          map2['image'],
                                          snapshots.data!.docs[i].id,
                                          map2['quantity']),
                                    );
                                  }),
                            ],
                          ),
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
