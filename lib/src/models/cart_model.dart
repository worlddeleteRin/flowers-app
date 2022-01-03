// import 'dart:core';

import 'package:myapp/src/models/catalogue_model.dart';

import 'package:myapp/src/blocs/cart_bloc.dart';

class LineItem {
  String id;
  String product_id;
  int quantity;
  int? promo_price;
  Product product;

  LineItem({
    required this.id,
    required this.product_id,
    this.quantity = 1,
    required this.product,
    this.promo_price
  });

  factory LineItem.fromJson(Map<String,dynamic> json) {
    
    Product lineItemProduct = json['product'] = 
      Product.fromJson(json['product']);
    return LineItem(
      id: json["id"],
      product_id: json["product_id"],
      quantity: json["quantity"],
      product: lineItemProduct,
      promo_price: json["promo_price"],
    );
  }

  Map<String,dynamic> toJson () =>
    {
      'id': this.id,
      'product_id': this.product_id,
      'quantity': this.quantity,
      'promo_price': this.promo_price,
    };

}

class Cart {
  String id;
  String? user_id;
  String? session_id;
  String? date_created;
  String? date_modified;
  List<LineItem> line_items;
  bool bonuses_used;
  int pay_with_bonuses;
  int? promo_amount;
  int? base_amount;
  int? discount_amount;
  int? promo_discount_amount;
  int? total_amount;
  // List<Coupon> coupons;
  // List<Product> coupon_gifts;
  int? bonuses_to_apply;

  Cart({
    required this.id, 
    this.user_id,
    this.session_id,
    this.date_created,
    this.date_modified,
    required this.line_items,
    required this.bonuses_used,
    required this.pay_with_bonuses,
    this.promo_amount,
    this.base_amount,
    this.discount_amount,
    this.promo_discount_amount,
    this.total_amount,
    // required this.coupons,
    // required this.coupon_gifts,
    this.bonuses_to_apply,
  });

  factory Cart.fromJson(Map<String,dynamic> json) {

    List<LineItem> line_items = json["line_items"].map<LineItem>((item) {
      LineItem line_item = LineItem.fromJson(item);
      return line_item;
    }).toList();

    return Cart(
      id: json["id"],
      user_id: json["user_id"],
      session_id: json["session_id"],
      date_created: json["date_created"],
      date_modified: json["date_modified"],
      line_items: line_items,
      bonuses_used: json["bonuses_used"],
      pay_with_bonuses: json["pay_with_bonuses"],
      promo_amount: json["promo_amount"],
      base_amount: json["base_amount"],
      discount_amount: json["discount_amount"],
      promo_discount_amount: json["promo_discount_amount"],
      total_amount: json["total_amount"],
      // coupons = null,
      // coupon_gifts = null,
      bonuses_to_apply: json["bonuses_to_apply"]
    );
  }

  LineItem? getLineItemById (String lineItemId) {
    LineItem? lineItem = this.line_items.firstWhere(
      (item) => item.id == lineItemId
    );
    return lineItem;
  }

  LineItem? getLineItemByProductId (String productId) {
    LineItem? lineItem = this.line_items.firstWhere(
      (item) => item.product_id == productId
    );
    return lineItem;
  }

  removeLineItem (String lineItemId) async {
    await cartBloc.removeCartItem(
      itemId: lineItemId,
    );
  }

  removeLineItemQuantity (String lineItemId) {
    LineItem? lineItem = getLineItemById(lineItemId);
    if (lineItem == null) {
      return;
    }
    if (lineItem.quantity > 1) {
      lineItem.quantity -= 1; 
      cartBloc.updateCartItem(
        lineItem: lineItem,
      );
    }
    else if (lineItem.quantity == 1) {
      cartBloc.removeCartItem(
        itemId: lineItemId,
      );
    }
  }

  addLineItemQuantity (String lineItemId) {
    LineItem? lineItem = getLineItemById(lineItemId);
    if (lineItem == null) {
      return;
    }
    lineItem.quantity += 1;
    cartBloc.updateCartItem(
      lineItem: lineItem,
    );
  }

  //
  LineItem? checkGetProductInCart(String productId) {
    bool lineItemExist = this.line_items.any((LineItem lineItem) =>
      lineItem.product_id == productId
    );     
    if (lineItemExist) {
      LineItem? lineItem = this.getLineItemByProductId(productId);
      return lineItem;
    }
    return null;
  }


}
