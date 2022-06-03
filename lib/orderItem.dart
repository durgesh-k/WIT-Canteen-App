import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  //const MenuCard({ Key? key }) : super(key: key);
  final String img;
  final String itemName;
  final String price;
  OrderItem(
    this.itemName,
    this.price,
    this.img,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 525,
      padding: const EdgeInsets.only(top: 8, right: 15, bottom: 5),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 70,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(img),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
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
                        itemName,
                        style: TextStyle(fontSize: 18),
                      ),
                      //SizedBox(width: 145),
                      Text(
                        price,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 191, 188, 188)),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(width: 120),
                    Container(
                      decoration: const BoxDecoration(
                          color: Color(0xFFE8460E),
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      //padding: const EdgeInsets.all(1),
                      //margin: const EdgeInsets.symmetric(horizontal: 3),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '-',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Text('2'),
                    SizedBox(width: 15),
                    Container(
                      decoration: const BoxDecoration(
                          color: Color(0xFFE8460E),
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      //padding: const EdgeInsets.all(1),
                      //margin: const EdgeInsets.symmetric(horizontal: 3),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '+',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
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
