import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            title: Text(
              'Edit Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Bold',
                  color: Colors.black.withOpacity(1),
                  fontSize: 28),
            ),
            //centerTitle: true,
            backgroundColor: Colors.black.withOpacity(0.02),
            shadowColor: Colors.transparent,
          ),
        ),
        body: Container());
  }
}
