// import 'dart:core';

import 'package:myapp/src/models/catalogue_model.dart';

import 'package:myapp/src/blocs/cart_bloc.dart';
import 'package:myapp/src/models/orders_model.dart';
import 'package:myapp/src/models/user_model.dart';

class CheckoutFormInfo {
  DeliveryMethod? delivery_method;
  PaymentMethod? payment_method;
  PickupAddress? pickup_address;
  UserDeliveryAddress? delivery_address;
}

class StockItem {
  String id;
  String title;
  String description;
  List<String> imgsrc;

  StockItem({
    required this.id,
    required this.title,
    this.description = "",
    required this.imgsrc,
  });

  factory StockItem.fromJson(Map<String,dynamic> json) {

    List<String> stockImages = json['imgsrc'].map<String>(
      (imgsrc) => imgsrc.toString()
    ).toList();

    return StockItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imgsrc: stockImages,
    );
  }

}
