import 'package:flutter/material.dart';
import 'package:myapp/src/models/catalogue_model.dart';

SnackBar ProductAddedSnackBar({
  required Product product,
}) {
  return SnackBar(
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.symmetric(
      vertical: 70.0, 
      horizontal: 10.0,
    ),
    content: Text('${product.name} добавлен в корзину'),
  );
}
