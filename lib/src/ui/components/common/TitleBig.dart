import 'package:flutter/material.dart';

Widget TitleBig({
  required String title,
  double fontSize = 30.0,
}) {
  return Text(
    "$title",
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
    )
  );
}
