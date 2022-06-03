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
      return ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: getHeight(context) * 0.5,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                height: getHeight(context) * 0.2,
                width: getWidth(context),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
              ElevatedButton(
                child: Text("Close Bottom Sheet"),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.green,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
