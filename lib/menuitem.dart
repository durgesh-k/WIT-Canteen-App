import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma_squircle/figma_squircle.dart';
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
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            decoration: BoxDecoration(
              //border: Border.all(color: Colors.grey.shade300),
              color: Colors.grey.withOpacity(0.1),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Stack(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: getHeight(context),
                  width: getWidth(context),
                  child: Image.network(
                    widget.img,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        height: getHeight(context) * 0.09,
                        width: getWidth(context),
                        color: Colors.white.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 10),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: getWidth(context) * 0.25,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.itemName,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Bold',
                                        color: Colors.white,
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
                                          fontFamily: 'Bold',
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _showModalBottomSheet(
                                      context,
                                      widget.id,
                                      widget.img,
                                      widget.itemName,
                                      widget.price);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Icon(
                                      Iconsax.add,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        !open
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: getHeight(context),
                  width: getWidth(context),
                  foregroundDecoration: BoxDecoration(
                    color: Colors.grey,
                    backgroundBlendMode: BlendMode.saturation,
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}

_showModalBottomSheet(context, id, image, name, price) {
  int quantity = 1;
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: ((context, setState) {
        return Container(
            height: getHeight(context) * 0.22,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(0)),
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 1,
                            ),
                            InkWell(
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
                          ],
                        ),*/
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            height: getHeight(context) * 0.09,
                            width: getHeight(context) * 0.09,
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                image: NetworkImage(image),
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
                          SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontFamily: 'SemiBold',
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (quantity > 1) {
                                              setState(() {
                                                quantity -= 1;
                                              });
                                            }
                                          },
                                          onDoubleTap: () {},
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(0))),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 18,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(quantity.toString(),
                                            style: TextStyle(
                                                fontFamily: 'SemiBold',
                                                fontSize: 18,
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              quantity += 1;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(0))),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
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
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "₹ ${price}",
                                    style: TextStyle(
                                      fontFamily: 'Bold',
                                      fontSize: 24,
                                      color: color,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('Carts')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('Items')
                                .doc(id)
                                .update({
                              'quantity': FieldValue.increment(quantity),
                            });
                          } catch (e) {
                            await FirebaseFirestore.instance
                                .collection('Carts')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('Items')
                                .doc(id)
                                .set({
                              'product': name,
                              'price': price,
                              'image': image,
                              'quantity': quantity,
                            });
                          }

                          showToast('$name added to cart');
                          try {
                            await FirebaseFirestore.instance
                                .collection('Carts')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('Sum')
                                .doc('0')
                                .update({
                              'sum': FieldValue.increment(
                                  int.parse(price) * quantity),
                              'quantity': FieldValue.increment(quantity)
                            });
                          } catch (e) {
                            await FirebaseFirestore.instance
                                .collection('Carts')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('Sum')
                                .doc('0')
                                .set({
                              'sum': price * quantity,
                              'quantity': quantity
                            });
                          }

                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(100)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 16),
                            child: Text(
                              'Add',
                              style: TextStyle(
                                  fontFamily: 'SemiBold',
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  /*Text(
                      '*This item with chosen quantity will be added to your cart')*/
                ],
              ),
            ));
      }));
    },
  );
}

class MenuItemHorizontal extends StatefulWidget {
  final String? img;
  final String? price;
  final String? product;
  final String? id;
  const MenuItemHorizontal(
      {Key? key, this.img, this.price, this.product, this.id})
      : super(key: key);

  @override
  State<MenuItemHorizontal> createState() => _MenuItemHorizontalState();
}

class _MenuItemHorizontalState extends State<MenuItemHorizontal> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: getHeight(context) * 0.2,
          width: getWidth(context) * 0.6,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(
                  image: NetworkImage(widget.img!), fit: BoxFit.cover)),
        ),
        Container(
          height: getHeight(context) * 0.2,
          width: getWidth(context) * 0.6,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.6),
                  ])),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: getHeight(context) * 0.08,
            width: getWidth(context) * 0.6,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product!,
                        style: TextStyle(
                            fontFamily: 'SemiBold',
                            fontSize: 26,
                            color: Colors.white),
                      ),
                      Text(
                        '₹ ${widget.price!}',
                        style: TextStyle(
                            fontFamily: 'Bold',
                            fontSize: 24,
                            color: Colors.white),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      _showModalBottomSheet(context, widget.id, widget.img,
                          widget.product, widget.price);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 14),
                          child: Text(
                            'Add',
                            style: TextStyle(
                                fontFamily: 'Bold', color: Colors.black),
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        !open
            ? ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  height: getHeight(context) * 0.2,
                  width: getWidth(context) * 0.6,
                  foregroundDecoration: BoxDecoration(
                    color: Colors.grey,
                    backgroundBlendMode: BlendMode.saturation,
                  ),
                ),
              )
            : Container()
      ],
    );
  }
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
    return Stack(
      children: [
        Container(
          width: getWidth(context) - 36,
          height: 120,
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
              image: DecorationImage(
                  image: NetworkImage(widget.img!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.srcATop,
                  ))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: getWidth(context) - 78,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${widget.percent!}%',
                                style: TextStyle(
                                    fontFamily: 'Bold',
                                    color: Colors.white,
                                    fontSize: 50),
                              ),
                              /*Text(
                                '  off\n',
                                style: TextStyle(
                                    fontFamily: 'SemiBoldItalic',
                                    color: Colors.white,
                                    fontSize: 30),
                              ),*/
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: getWidth(context) * 0.5,
                                child: Text(
                                  'off ${widget.condition!}',
                                  style: TextStyle(
                                      fontFamily: 'SemiBold',
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 18),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  /*_showModalBottomSheet(context, widget.id, widget.img,
                              widget.product, widget.price);*/
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0, vertical: 10),
                                      child: Text(
                                        '→',
                                        style: TextStyle(
                                            fontFamily: 'Bold',
                                            color: Colors.black),
                                      )),
                                ),
                              )
                            ],
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
        ),
        !open
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: getWidth(context) - 36,
                  height: 120,
                  foregroundDecoration: BoxDecoration(
                    color: Colors.grey,
                    backgroundBlendMode: BlendMode.saturation,
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
