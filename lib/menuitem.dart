import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wit_canteen_app/globals.dart';

class Menuitem extends StatefulWidget {
  //final Menuitem({Key? key}) : super(key: key);

  final String img;
  final String itemName;
  final String price;
  final String id;

  Menuitem(this.itemName, this.price, this.img, this.id);

  @override
  State<Menuitem> createState() => _MenuitemState();
}

class _MenuitemState extends State<Menuitem> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: getHeight(context) * 0.17,
              width: getWidth(context),
              child: Image.network(
                widget.img,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.itemName,
                        style: TextStyle(
                          fontFamily: 'SemiBold',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      /*Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: const Text(
                      'Quantity 1',
                    ),
                  ),*/
                      Text(
                        "₹ ${widget.price}",
                        style: TextStyle(
                            fontFamily: 'Medium',
                            fontSize: 22,
                            color: Colors.black.withOpacity(0.7),
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      _showModalBottomSheet(context, widget.id, widget.img,
                          widget.itemName, widget.price);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Iconsax.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

_showModalBottomSheet(context, id, image, name, price) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              height: getHeight(context) * 0.5,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Column(
                children: [
                  Container(
                    height: getHeight(context) * 0.3,
                    width: getWidth(context),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: getWidth(context),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontFamily: 'SemiBold',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                              Text(
                                "₹ ${price}",
                                style: TextStyle(
                                    fontFamily: 'Medium',
                                    fontSize: 32,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          InkWell(
                            onTap: () async {
                              await FirebaseFirestore.instance
                                  .collection('Carts')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('Items')
                                  .doc(id)
                                  .set({
                                'product': name,
                                'price': price,
                                'image': image,
                                'quantity': 1,
                              });

                              showToast('$name added to cart');
                              try {
                                await FirebaseFirestore.instance
                                    .collection('Carts')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('Sum')
                                    .doc('0')
                                    .update({
                                  'sum': FieldValue.increment(int.parse(price))
                                });
                              } catch (e) {
                                await FirebaseFirestore.instance
                                    .collection('Carts')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('Sum')
                                    .doc('0')
                                    .set({'sum': price});
                              }

                              Navigator.of(context).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 10),
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                      fontFamily: 'SemiBold',
                                      fontSize: 24,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 20,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                    )),
              ),
            ),
          ),
        ],
      );
    },
  );
}

class OfferItem extends StatefulWidget {
  final String? img;
  final String? condition;
  final String? percent;
  const OfferItem({Key? key, this.img, this.condition, this.percent})
      : super(key: key);

  @override
  State<OfferItem> createState() => _OfferItemState();
}

class _OfferItemState extends State<OfferItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(context) * 0.44,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
          image: DecorationImage(
              image: NetworkImage(widget.img!),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2),
                BlendMode.srcATop,
              ))),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: getWidth(context) * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${widget.percent!} %',
                            style: TextStyle(
                                fontFamily: 'SemiBold',
                                color: Colors.white,
                                fontSize: 40),
                          ),
                          Text(
                            ' off',
                            style: TextStyle(
                                fontFamily: 'SemiBoldItalic',
                                color: Colors.white,
                                fontSize: 20),
                          ),
                        ],
                      ),
                      Text(
                        widget.condition!,
                        style: TextStyle(
                            fontFamily: 'SemiBold',
                            color: Colors.white,
                            fontSize: 12),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
