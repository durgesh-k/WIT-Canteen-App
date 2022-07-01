import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wit_canteen_app/auth/auth_backend.dart';
import 'package:wit_canteen_app/globals.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Bold',
              color: Colors.black.withOpacity(0.7),
              fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: getWidth(context) * 0.6,
                      child: Text(
                        FirebaseAuth.instance.currentUser!.displayName!,
                        style: TextStyle(fontFamily: 'SemiBold', fontSize: 28),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: Color(0xFFE8460E),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'EDIT',
                        style: TextStyle(
                            fontFamily: 'SemiBold',
                            fontSize: 14,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7, left: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(FirebaseAuth.instance.currentUser!.email!,
                        style: TextStyle(
                            fontFamily: 'SemiBold',
                            fontSize: 20,
                            color: Color.fromARGB(255, 189, 187, 187))),
                    SizedBox(height: 10),
                    Text('TYBTech - 19031009',
                        style: TextStyle(
                            color: Color.fromARGB(255, 189, 187, 187))),
                    SizedBox(height: 10),
                    Text(FirebaseAuth.instance.currentUser!.phoneNumber!,
                        style: TextStyle(
                            fontFamily: 'SemiBold',
                            fontSize: 20,
                            color: Color.fromARGB(255, 189, 187, 187))),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 25, left: 35, right: 35, bottom: 25),
                child: Text(
                    '_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 189, 187, 187))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order History',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Text('About',
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
      ),
    );
  }
}
