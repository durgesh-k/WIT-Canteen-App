import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({ Key? key }) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          title: Text(
            'About',
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
      body: Container()
    );
  }
}