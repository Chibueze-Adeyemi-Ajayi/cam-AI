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
   
      canvas.drawPoints(PointMode.points, offsets, paint1);
   
    // linking the shoulders together
    canvas.drawLine(offsets[0], offsets[1], paint2);
    // linking left shoulder with left elbow
    canvas.drawLine(offsets[1], offsets[3], paint2);
    // linking left elbow with left l=wrist
    canvas.drawLine(offsets[3], offsets[5], paint2);
    // linking right shoulder with right elbow
    canvas.drawLine(offsets[0], offsets[2], paint2);
    // linking right shoulder with right wrist
    canvas.drawLine(offsets[2], offsets[4], paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}