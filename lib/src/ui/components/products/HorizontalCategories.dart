import 'package:flutter/material.dart';
import 'dart:core';

import 'package:myapp/src/models/catalogue_model.dart';
import 'package:myapp/src/ui/components/products/CategoryCard.dart';

Widget HorizontalCategories({
    required BuildContext context,
    required List<Category> categories,
  }) {
  // const Map<String,dynamic> categories = {};
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
  return Container(
    height: 150.0,
    child: ListView(
      scrollDirection: Axis.horizontal, 
      children: categoriesList,
    ),
  );
}
