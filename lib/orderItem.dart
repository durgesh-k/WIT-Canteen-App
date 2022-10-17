import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma_squircle/figma_squircle.dart';
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
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.img),
                    fit: BoxFit.cover,
                  ),
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                      cornerRadius: 24,
                      cornerSmoothing: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width -
                    getHeight(context) * 0.12 -
                    36,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.itemName,
                      style: TextStyle(
                        fontFamily: 'SemiBold',
                        fontSize: 20,
                      ),
                    ),
                    //SizedBox(width: 145),
                  ],
                ),
              ),
              SizedBox(
                height: getHeight(context) * 0.01,
              ),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Row(
                      children: [
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
                                'sum': FieldValue.increment(
                                    -int.parse(widget.price)),
                                'quantity': FieldValue.increment(-1)
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
                            /*setState(() {
                              //subtotal = subtotal - int.parse(widget.price);
                            });*/
                          },
                          onDoubleTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0))),
                            child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.remove,
                                  size: 18,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(widget.quantity.toString(),
                            style: TextStyle(
                                fontFamily: 'SemiBold',
                                fontSize: 18,
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.w500)),
                        SizedBox(width: 10),
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
                              'sum':
                                  FieldValue.increment(int.parse(widget.price)),
                              'quantity': FieldValue.increment(1)
                            });
                            setState(() {
                              //subtotal = subtotal + int.parse(widget.price);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0))),
                            child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.add,
                                  size: 18,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    '₹ ${widget.price}',
                    style: TextStyle(
                      fontFamily: 'SemiBold',
                      fontSize: 20,
                      color: color,
                    ),
                  ),
                ],
              ),
              /*Row(
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
                ],
              ),*/
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
      /*decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80),
          border: Border.all(color: color2, width: 2)),*/
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Row(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    height: getHeight(context) * 0.05,
                    width: getHeight(context) * 0.05,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.img),
                        fit: BoxFit.cover,
                      ),
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 30,
                          cornerSmoothing: 0.0,
                        ),
                      ),
                    ),
                  ),
                  //const SizedBox(height: 5),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    //color: color,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.itemName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Bold',
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '₹ ${widget.price}',
                                  style: TextStyle(
                                    fontFamily: 'SemiBold',
                                    fontSize: 16,
                                    color: Colors.black.withOpacity(1),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Qty: ${widget.quantity} ',
                                  style: TextStyle(
                                    fontFamily: 'SemiBold',
                                    fontSize: 16,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        //SizedBox(width: 145),
                        /*Container(
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
                        )*/
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
