import 'package:flutter/material.dart';

Widget SimpleCheckBoxListTile({
  required String title,
  required bool value,
  required Function(bool?) onChanged,
}) {
  return GestureDetector(
    onTap: () => onChanged(!value),
    child: Container(
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: (bool? checkboxValue) => 
            onChanged(checkboxValue),
          ),
          Text(
            "$title",
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            )
          ),
        ]
      ),
    ),
  );
}
