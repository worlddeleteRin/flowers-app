import 'package:flutter/material.dart';

Widget CartEmptyBlock ({
  required BuildContext context,
}) {

  goCataloguePage() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    /*
    Navigator.pushNamed(
      context, 
      '/home',
    );
    */
  }

  Widget emptyTitleBlock =
  Center(
    child: Text(
      "Ваша корзина пуста",
      style: TextStyle(
        fontSize: 18.0, 
        fontWeight: FontWeight.w500,
      )
    ),
  );

  Widget goCatalogueButton = 
  Container(
    height: 40.0,
    child: ElevatedButton(
      onPressed: () => goCataloguePage(),
      child: Text(
        'Перйти в каталог',
        style: TextStyle(
          fontSize: 15.0,
        ),
      ),
    ),
  );

  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        emptyTitleBlock,
        SizedBox(height: 15.0),
        goCatalogueButton,
      ]
    )
  );
}
