import 'package:flutter/material.dart';
import 'package:myapp/src/models/catalogue_model.dart';
import 'package:myapp/src/ui/components/products/ProductPageContent.dart';

Widget DraggableProductPage({
  required BuildContext context,
  required Product product,
}) {
    return SafeArea(
    child: DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, ScrollController scrollController) {

      return SingleChildScrollView(
        controller: scrollController,
        child: ProductPageContent(
          context: context,
          product: product,
          scrollController: scrollController,
        ),
      );

      }
    ),
  );
}
