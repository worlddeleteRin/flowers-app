import 'package:flutter/material.dart';

Widget ProductButtonLoading () {
  return Container(
    width: 10.0,
    height: 10.0,
    child: CircularProgressIndicator(
      strokeWidth: 2.0,
      color: Colors.white,
    ),
  );
}
