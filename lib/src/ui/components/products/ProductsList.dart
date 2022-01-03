import 'package:flutter/material.dart';
import 'package:myapp/src/models/catalogue_model.dart';
import 'dart:core';

// local imports
import 'package:myapp/src/ui/components/products/ProductCard.dart';

Widget ProductsList({
    required BuildContext context,
    required List<Product> products,
  }) {

  /*
  final productsList = products.map((product) =>
      ProductCard(
        context: context,
        product: product,
      ),
  ).toList();
  */

  return GridView.builder(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      mainAxisExtent: 255.0,
      crossAxisCount: 2,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
    ),    
    itemCount: products.length,
    itemBuilder: (BuildContext context, int index) {
      return ProductCard(
        product: products[index],
      );
    },
  );
/*
  return GridView(
    padding: EdgeInsets.symmetric(horizontal: 8.0),
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),

    children: productsList,
  );
*/

/*
return SliverGrid(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    mainAxisExtent: 270.0,
    crossAxisCount: 2,
    mainAxisSpacing: 10.0,
    crossAxisSpacing: 10.0,
  ),
  delegate: SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      Product product = products[index];
      return ProductCard(
        context: context,
        product: product,
      );
    },
    childCount: products.length,
  )
  // childAspectRatio: ,
  // crossAxisCount: 2,
  // children: productsList,
);
*/

}
