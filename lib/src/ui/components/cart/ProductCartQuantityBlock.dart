import 'package:flutter/material.dart';

Widget ProductCartQuantityBlock({
  required Function handleAddQuantity, 
  required Function handleRemoveQuantity, 
  required String quantity,
  required bool useButtonBackgroundColor,
}) {
  return Container(
    child: Row(
      children: [
        productCartQuantityButton(
          handleClick: () async => await handleRemoveQuantity(),
          icon: Icon(Icons.remove),
          useButtonBackgroundColor: useButtonBackgroundColor,
        ),
        Container(
          width: 50.0,
          child: Center(
            child: Text('$quantity'),
          ),
        ),
        productCartQuantityButton(
          handleClick: () async => await handleAddQuantity(),
          icon: Icon(Icons.add),
          useButtonBackgroundColor: useButtonBackgroundColor,
        ),
      ]
    )
  );
}

 Widget productCartQuantityButton({
    required Function handleClick,
    required Icon icon,
    required bool useButtonBackgroundColor,
  }) {
    Color buttonBackgroundColor;

    if (useButtonBackgroundColor) {
      buttonBackgroundColor = Colors.black.withOpacity(0.1); 
    } else {
      buttonBackgroundColor = Colors.transparent; 
    }

    return Container(
      width: 55.0,
      child: Column(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () async => await handleClick(),
              child: icon,
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.all(0.0)
                ),
                backgroundColor: MaterialStateProperty.all(
                  buttonBackgroundColor,
                )
              ),
            ),
          ),
        ]
      ),
    );
  }

