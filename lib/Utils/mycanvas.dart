import 'dart:ui';

import 'package:flutter/cupertino.dart';
// this is this the paint application for displaying detected poses
// expected input is a pose list
class OpenPainter extends CustomPainter {
const OpenPainter({required this.offsets});
final List<Offset> offsets;
@override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(0xff63aa65)
      ..strokeWidth = 5;
     var paint2 = Paint()
      ..color = Color.fromARGB(255, 255, 39, 1)
      ..strokeWidth = 1;
    //list of points
    var length = offsets.length / 2;
    // for (var i = 0; i < length; i++) {
      canvas.drawPoints(PointMode.points, offsets, paint1);
    // }
    // linking the shoulders together
    canvas.drawLine(offsets[0], offsets[1], paint2);
    
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}