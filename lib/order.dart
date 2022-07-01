import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotreloader/hotreloader.dart';
import 'package:wit_canteen_app/globals.dart';
import 'package:wit_canteen_app/orderItem.dart';
import 'package:wit_canteen_app/order_backend.dart';
import 'package:wit_canteen_app/priceBoard.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;
      });
  }

  void getSub() {
    var doc = FirebaseFirestore.instance
        .collection('Carts')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Sum')
        .doc('0')
        .get()
        .then((value) {
      setState(() {
        //subtotal = value.data()!['sum'];
        loading = false;
      });
    });
  }

  Future<void> getSum() async {
    var docs = await FirebaseFirestore.instance
        .collection('Carts')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Items')
        .get();
    print('here--${docs.docs.length}');
    docs.docs.forEach((element) async {
      setState(() {
        num value =
            int.parse(element.data()["price"]) * element.data()["quantity"];
        //subtotal = subtotal + value.toInt();
        loading = false;
      });
    });
  }

  bool? loading = true;

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
      body: /* loading!
          ? Container(
              child: Center(
                  child: Container(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator())))
          : */
          Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FirebaseAuth.instance.currentUser!.displayName!,
                style: const TextStyle(
                  fontFamily: 'SemiBold',
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                FirebaseAuth.instance.currentUser!.phoneNumber!,
                style: TextStyle(
                    fontFamily: 'Medium',
                    fontSize: 20,
                    color: Colors.black.withOpacity(0.4)),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 1,
                width: getWidth(context),
                color: Colors.grey.shade200,
              ),
              const SizedBox(
                height: 20,
              ),
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

                          return OrderItem(
                              map['product'],
                              map['price'].toString(),
                              map['image'],
                              snapshot.data!.docs[i].id,
                              map['quantity']);
                        },
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(
                height: 40,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Carts')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('Sum')
                    .snapshots(),
                builder: (ctx, snapshot) {
                  if (!snapshot.hasData) return Container();
                  if (snapshot.data!.docs.length != 0) {
                    return Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style:
                                TextStyle(fontFamily: 'SemiBold', fontSize: 24),
                          ),
                          Text(
                            snapshot.data!.docs[0]['sum'].toString(),
                            style:
                                TextStyle(fontFamily: 'SemiBold', fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Delivery',
                            style:
                                TextStyle(fontFamily: 'SemiBold', fontSize: 24),
                          ),
                          Text(
                            'Free',
                            style:
                                TextStyle(fontFamily: 'SemiBold', fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        height: 1,
                        width: getWidth(context),
                        color: Colors.grey.shade200,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('To Pay',
                              style:
                                  TextStyle(fontFamily: 'Bold', fontSize: 28)),
                          Text('₹ ${snapshot.data!.docs[0]['sum'].toString()}',
                              style:
                                  TextStyle(fontFamily: 'Bold', fontSize: 28)),
                        ],
                      )
                    ]);
                  } else {
                    return Container();
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pickup time',
                    style:
                        const TextStyle(fontFamily: 'SemiBold', fontSize: 24),
                  ),
                  InkWell(
                    onTap: () {
                      _selectTime(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: color2,
                          borderRadius: BorderRadius.circular(40)),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: Text(
                            selectedTime.format(context),
                            style:
                                TextStyle(fontFamily: 'SemiBold', fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              Container(
                height: 70,
                width: getWidth(context) * 0.47,
              ),
              /*InkWell(
                onTap: () {
                  onGooglePayPressed();
                },
                child: Container(
                    height: 60,
                    width: getWidth(context) * 0.1,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    child: const Center(
                      child: Text(
                        'Google Pay',
                        style: TextStyle(
                            fontFamily: 'SemiBold',
                            color: Colors.blue,
                            fontSize: 24),
                      ),
                    )),
              ),*/
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Carts')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('Sum')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    if (snapshot.data!.docs.length != 0) {
                      return InkWell(
                        onTap: () {
                          pay(context, snapshot.data!.docs[0]['sum'].toString(),
                              FirebaseAuth.instance.currentUser!.uid);
                        },
                        child: Container(
                            height: 60,
                            width: getWidth(context) * 0.4,
                            decoration: const BoxDecoration(
                                color: Color(0xFFE8460E),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                            child: const Center(
                              child: Text(
                                'Place Order',
                                style: TextStyle(
                                    fontFamily: 'SemiBold',
                                    color: Colors.white,
                                    fontSize: 24),
                              ),
                            )),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
