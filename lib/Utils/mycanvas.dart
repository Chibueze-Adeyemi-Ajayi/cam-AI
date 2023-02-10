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
    //list of points
    var length = offsets.length / 2;
    for (var i = 0; i < length; i++) {
      canvas.drawLine(offsets[i], offsets[i], paint1);
    }
    
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}