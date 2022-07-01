import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wit_canteen_app/globals.dart';

class OrderItem extends StatefulWidget {
  //const MenuCard({ Key? key }) : super(key: key);
  final String img;
  final String itemName;
  final String price;
  final String id;
  final int quantity;
  OrderItem(this.itemName, this.price, this.img, this.id, this.quantity);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                height: getHeight(context) * 0.09,
                width: getHeight(context) * 0.09,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.img),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(28)),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
        const SizedBox(width: 30),
        Container(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.58,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.itemName,
                      style: TextStyle(
                        fontFamily: 'SemiBold',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    //SizedBox(width: 145),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹ ${widget.price}',
                    style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 22,
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 120),
                  InkWell(
                    onTap: () async {
                      int prev = widget.quantity;
                      await FirebaseFirestore.instance
                          .collection('Carts')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('Items')
                          .doc(widget.id)
                          .update({'quantity': FieldValue.increment(-1)});
                      try {
                        await FirebaseFirestore.instance
                            .collection('Carts')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('Sum')
                            .doc('0')
                            .update({
                          'sum': FieldValue.increment(-int.parse(widget.price))
                        });
                      } catch (e) {}

                      if (prev == 1) {
                        FirebaseFirestore.instance
                            .collection('Carts')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('Items')
                            .doc(widget.id)
                            .delete();
                        // FirebaseFirestore.instance
                        //     .collection('Carts')
                        //     .doc(FirebaseAuth.instance.currentUser!.uid)
                        //     .collection('Sum')
                        //     .doc('0')
                        //     .delete();
                        showToast('Removed ${widget.itemName} from cart');
                      }
                      setState(() {
                        //subtotal = subtotal - int.parse(widget.price);
                      });
                    },
                    onDoubleTap: () {},
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Color(0xFFE8460E),
                          borderRadius: BorderRadius.all(Radius.circular(17))),
                      child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.remove,
                            size: 18,
                            color: Colors.white,
                          )),
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(widget.quantity.toString(),
                      style: TextStyle(
                          fontFamily: 'Medium',
                          fontSize: 22,
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.w500)),
                  SizedBox(width: 15),
                  InkWell(
                    onTap: () async {
                      await FirebaseFirestore.instance
                          .collection('Carts')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('Items')
                          .doc(widget.id)
                          .update({'quantity': FieldValue.increment(1)});
                      await FirebaseFirestore.instance
                          .collection('Carts')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('Sum')
                          .doc('0')
                          .update({
                        'sum': FieldValue.increment(int.parse(widget.price))
                      });
                      setState(() {
                        //subtotal = subtotal + int.parse(widget.price);
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Color(0xFFE8460E),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class OrderSuccessItem extends StatefulWidget {
  //const MenuCard({ Key? key }) : super(key: key);
  final String img;
  final String itemName;
  final String price;
  final String id;
  final int quantity;
  OrderSuccessItem(this.itemName, this.price, this.img, this.id, this.quantity);

  @override
  State<OrderSuccessItem> createState() => _OrderSuccessItemState();
}

class _OrderSuccessItemState extends State<OrderSuccessItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80),
          border: Border.all(color: color2, width: 2)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Row(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    height: getHeight(context) * 0.05,
                    width: getHeight(context) * 0.05,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.img),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            const SizedBox(width: 30),
            Container(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              widget.itemName,
                              style: TextStyle(
                                fontFamily: 'SemiBold',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '₹ ${widget.price}',
                              style: TextStyle(
                                  fontFamily: 'Medium',
                                  fontSize: 22,
                                  color: Colors.black.withOpacity(0.7),
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        //SizedBox(width: 145),
                        Container(
                          decoration: BoxDecoration(
                              color: color2,
                              borderRadius: BorderRadius.circular(50)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              ' x${widget.quantity} ',
                              style: TextStyle(
                                  fontFamily: 'Medium',
                                  fontSize: 22,
                                  color: Colors.black.withOpacity(0.7),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
