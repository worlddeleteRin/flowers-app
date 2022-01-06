import 'package:flutter/material.dart';
import 'dart:core';

import 'package:myapp/src/models/catalogue_model.dart';
import 'package:myapp/src/ui/components/products/ProductCard.dart';
// import 'package:myapp/src/ui/components/products/CategoryCard.dart';

Widget HorizontalProducts({
    required BuildContext context,
    required List<Product> products,
  }) {
  // const Map<String,dynamic> categories = {};
  /*
  final categoriesList = categories.map((category) =>
    Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      width: 150.0, 
      height: 100.0,
      child: CategoryCard(
        context: context,
        category: category,
      ),
    )
  ).toList();
  */
  return Container(
    height: 250.0,
    // width: 100.0,
    child: ListView.builder(
      scrollDirection: Axis.horizontal, 
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          width: 150.0,
          margin: EdgeInsets.symmetric(
            horizontal: 5.0,
          ),
          child: ProductCard(
            product: products[index],
          ),
        );
      }
    ),
  );
}
