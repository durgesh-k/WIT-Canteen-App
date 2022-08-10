import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wit_canteen_app/menuitem.dart';

class MenuGrid extends StatelessWidget {
  /*
  List<Menuitem> listOfItems = <Menuitem>[
    Menuitem('Vadapav', "15", 'assets/images/vadapav.jpg'),
    Menuitem('Samosa', "15", 'assets/images/samosa.jpg'),
    Menuitem('Sangam Vada', "20", 'assets/images/sangamvada.jpg'),
    Menuitem('Kachori', "15", 'assets/images/kachori.jpg'),
    Menuitem('Idli', "30", 'assets/images/idli.jpg'),
    Menuitem('Tea', "15", 'assets/images/tea.jpg'),
  ];*/

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Menu').snapshots(),
      builder: ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        int count = snapshot.data!.docs.length;
        return GridView.count(
          //physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 9 / 11.6,
          padding: EdgeInsets.all(5),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: List.generate(count, (index) {
            Map<String, dynamic> map =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return Menuitem(map['product'], map['price'].toString(),
                map['image'], snapshot.data!.docs[index].id);
          }),
        );
      }),
    );
  }
}
