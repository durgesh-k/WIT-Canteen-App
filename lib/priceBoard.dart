import 'package:flutter/material.dart';

class PriceBoard extends StatelessWidget {
  const PriceBoard({Key? key}) : super(key: key);

  get fontWeight => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 625,
      padding: const EdgeInsets.only(top: 30, right: 20, bottom: 5, left: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Subtotal',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '₹ 84.50',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Delivery',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Free',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('TOTAL',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('₹ 84.50',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFFE8460E))),
          ],
        )
      ]),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 0.5,
            offset: Offset(2, 5), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
