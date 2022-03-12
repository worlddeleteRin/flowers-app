import 'package:flutter/material.dart';

Widget SimpleInputErrorLabel({
  required String title
}) {
  return Container(
    child: Text(
      '${title}',
      style: TextStyle(
        color: Colors.red
      )
    )
  );
}
