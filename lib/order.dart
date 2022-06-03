import 'package:flutter/material.dart';
import 'package:wit_canteen_app/orderItem.dart';
import 'package:wit_canteen_app/priceBoard.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MY ORDER',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        child: Column(
          children: [
            OrderItem('Samosa', '₹ 15', 'assets/images/samosa.jpg'),
            OrderItem('Vadapav', '₹ 15', 'assets/images/vadapav.jpg'),
            OrderItem('Kachori', '₹ 15', 'assets/images/kachori.jpg'),
            PriceBoard(),
            SizedBox(height: 10),
            Container(
              decoration: const BoxDecoration(
                  color: Color(0xFFE8460E),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              padding: const EdgeInsets.all(1),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              child: SizedBox(
                height: 50,
                width: 370,
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Confirm Order',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
