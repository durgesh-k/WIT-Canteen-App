import 'package:flutter/material.dart';
import 'package:wit_canteen_app/globals.dart';

class PriceBoard extends StatefulWidget {
  final int? total;
  const PriceBoard({Key? key, this.total}) : super(key: key);

  @override
  State<PriceBoard> createState() => _PriceBoardState();
}

class _PriceBoardState extends State<PriceBoard> {
  get fontWeight => null;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Subtotal',
            style: TextStyle(fontFamily: 'SemiBold', fontSize: 24),
          ),
          Text(
            widget.total.toString(),
            style: TextStyle(fontFamily: 'SemiBold', fontSize: 20),
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
            style: TextStyle(fontFamily: 'SemiBold', fontSize: 24),
          ),
          Text(
            'Free',
            style: TextStyle(fontFamily: 'SemiBold', fontSize: 20),
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
          Text('To Pay', style: TextStyle(fontFamily: 'Bold', fontSize: 28)),
          Text('₹ ${widget.total}',
              style: TextStyle(fontFamily: 'Bold', fontSize: 28)),
        ],
      )
    ]);
  }
}
