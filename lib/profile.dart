import 'package:flutter/material.dart';
import 'package:wit_canteen_app/auth/auth_backend.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 35),
              margin: EdgeInsets.only(top: 25, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nandni Jogiji',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFFE8460E),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    padding: const EdgeInsets.all(1),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    child: SizedBox(
                      height: 25,
                      width: 45,
                      child: TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'EDIT',
                          style: TextStyle(
                              fontSize: 10, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7, left: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('nandnijogiji15@gmail.com',
                      style:
                          TextStyle(color: Color.fromARGB(255, 189, 187, 187))),
                  SizedBox(height: 10),
                  Text('TYBTech - 19031009',
                      style:
                          TextStyle(color: Color.fromARGB(255, 189, 187, 187))),
                  SizedBox(height: 10),
                  Text('+917448047183',
                      style:
                          TextStyle(color: Color.fromARGB(255, 189, 187, 187))),
                ],
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(top: 25, left: 35, right: 35, bottom: 25),
              child: Text(
                  '_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ ',
                  style: TextStyle(color: Color.fromARGB(255, 189, 187, 187))),
            ),
            Padding(
              padding: EdgeInsets.only(left: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order History',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text('About', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      logOut(context);
                    },
                    child: Text('Log Out',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 280),
                  Text('WIT COLLEGE',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: (Color.fromARGB(255, 214, 214, 214)),
                          fontSize: 20)),
                  Text(
                    'CANTEEN',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: (Color.fromARGB(255, 214, 214, 214)),
                        fontSize: 20),
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
