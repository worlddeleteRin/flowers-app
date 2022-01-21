import 'package:flutter/material.dart';

Widget SelectableListTile({
  required Function handleTap,
  required String title,
  required Widget trailingBody,
}) {

  Widget trailingContent = 
  Container(
    width: 200.0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
        child: trailingBody,
        ),
        Icon(
          Icons.chevron_right,
          color: Colors.black,
        ),
      ]
    ),
  );

  return ListTile(
    contentPadding: EdgeInsets.symmetric(
      horizontal: 0.0
    ),
    title: Text(
      '$title',
    ),
    trailing: trailingContent,
    onTap: () => handleTap(),
  );
}
