import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('О Нас'),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 14.0,
            vertical: 10.0,
          ),
          child: Text('about us content will be here')
        ),
      )
    );
  }

}
