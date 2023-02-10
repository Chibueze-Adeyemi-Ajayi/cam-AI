import 'dart:ui';

import 'package:flutter/cupertino.dart';
// this is this the paint application for displaying detected poses
// expected input is a pose list
class OpenPainter extends CustomPainter {
OpenPainter({required offsets});
final Offset offsets;
@override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(0xff63aa65)
      ..strokeWidth = 5;
    //list of points
    canvas.drawLine(Offset(0, 0), Offset(100, 100), paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}