import 'package:flutter/material.dart';

Widget SimpleBottomActionContainer({
  required String buttonTitle,
  required Function handleClick,
  bool disabled = false
}) {

  return SafeArea(
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 50.0,
            margin: EdgeInsets.only(
              bottom: 10.0,
            ),
            child: ElevatedButton(
              onPressed: disabled ? null : () => handleClick(),
              // onPressed: null,
              child: Text(
                "$buttonTitle",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                )
              )
            ),
          )
        ),
      ]
    ),
  );

}
