import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget NavigationTitle ({
  required BuildContext context,
  required String title,
  String navText = "Все",
  required Function handleRouteClick,
}) {

  /*
  navigatePage () {
    Navigator.pushNamed(
      context,
      pageRouteName,
    );
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (BuildContext context) {
          return ();
        }
      ),
    );
    */

  Widget titleBlock =
  Row(
    children: [
      Container(
        constraints: BoxConstraints(
          maxWidth: 240.0,
        ),
        child: Text(
          title,
          softWrap: true,
          style: TextStyle(
            color: Colors.black,
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ]
  );

  Widget linkButtonBlock =
  TextButton(
    // padding: EdgeInsets.all(0),
    onPressed: () { handleRouteClick(); },
    child: Row(
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: 100.0,
          ),
          child: Text(
            navText,
          ),
        ),
        Icon(
          Icons.chevron_right,
        )
      ]
    ),
  );

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      titleBlock,
      Column(
        children: [
          linkButtonBlock,
        ]
      ),
    ]
  );
}
