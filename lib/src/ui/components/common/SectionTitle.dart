import 'package:flutter/material.dart';

Widget SectionTitle ({
  required BuildContext context,
  required String title
}) {
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: 4.0,
      horizontal: 17.0
    ),
    decoration: BoxDecoration(
      color: Colors.black87,
      borderRadius: BorderRadius.circular(12.0)
    ),
    child: Text(
      "${title}",
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
          color: Colors.white
      )
    ) 
  );
}
