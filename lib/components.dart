import 'package:flutter/material.dart';

class CircularProgress extends StatefulWidget {
  final Color? color;
  final double? size;

  const CircularProgress({this.color, this.size});

  @override
  _CircularProgressState createState() => _CircularProgressState();
}

class _CircularProgressState extends State<CircularProgress> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size,
      width: widget.size,
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(widget.color!),
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}
