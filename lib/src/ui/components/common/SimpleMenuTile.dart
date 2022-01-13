  import 'package:flutter/material.dart';

Widget SimpleMenuTile({
  required String title,
  required Function handleTap
}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
            Radius.circular(15.0)
          )
      ),
      child: ListTile(
        textColor: Colors.black,
        title: Text(
          "$title",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
          )
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.black,
        ),
        onTap: () => handleTap(),
      ),
    );
}
