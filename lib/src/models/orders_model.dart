import 'package:myapp/src/models/cart_model.dart';
import 'package:myapp/src/models/common_model.dart';
import 'package:myapp/src/models/user_model.dart';

class OrderStatus {
  String id;
  String name;
  String name_display;
  ColorARGB color;

  OrderStatus({
    required this.id,
    required this.name,
    required this.name_display,
    required this.color
  });

  factory OrderStatus.fromJson(Map<String,dynamic> json) {
    ColorARGB orderStatusColor = 
    ColorARGB.fromJson(json['color']);
    return OrderStatus(
      id: json['id'],
      name: json['name'],
      name_display: json['name_display'],
      color: orderStatusColor,
    );
  }
}

class PaymentMethod {
  String id;
  String name;
  PaymentMethod({
    required this.id,
    required this.name
  });
  factory PaymentMethod.fromJson(Map<String,dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      name: json['name'],
    );
  }
}

class DeliveryMethod {
  String id;
  String name;
  DeliveryMethod({
    required this.id,
    required this.name
  });
  factory DeliveryMethod.fromJson(Map<String,dynamic> json) {
    return DeliveryMethod(
      id: json['id'],
      name: json['name'],
    );
  }
}

class PickupAddress {
  String id;
  String name;
  PickupAddress({
    required this.id,
    required this.name
  });
  factory PickupAddress.fromJson(Map<String,dynamic> json) {
    return PickupAddress(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Order {
  Cart cart;
  OrderStatus status;
  String date_created;
  String date_modified;
  PaymentMethod payment_method;
  DeliveryMethod delivery_method;
  UserDeliveryAddress? delivery_address;
  PickupAddress? pickup_address;
  String custom_message;

  Order({
    required this.cart,
    required this.status,
    required this.date_created,    
    required this.date_modified,
    required this.payment_method,
    required this.delivery_method,
    this.delivery_address,
    this.pickup_address,
    required this.custom_message,
  });

  factory Order.fromJson(Map<String,dynamic> json) {

    Cart orderCart = Cart.fromJson(json['cart']); 

    OrderStatus orderStatus = OrderStatus.fromJson(
      json['status']
    );

    PaymentMethod orderPaymentMethod = PaymentMethod.fromJson(
      json['payment_method']
    );

    DeliveryMethod orderDeliveryMethod = DeliveryMethod.fromJson(
      json['delivery_method']
    );

    UserDeliveryAddress? orderDeliveryAddress = 
    json['delivery_address'] == null ?
    null:
    UserDeliveryAddress.fromJson(json['delivery_address']);

    PickupAddress? orderPickupAddress = 
    json['pickup_address'] == null ?
    null:
    PickupAddress.fromJson( json['pickup_address']);

    return Order(
      cart: orderCart, 
      status: orderStatus,
      date_created: json['date_created'],
      date_modified: json['date_modified'],
      payment_method: orderPaymentMethod,
      delivery_method: orderDeliveryMethod,
      delivery_address: orderDeliveryAddress,
      pickup_address: orderPickupAddress,
      custom_message: json['custom_message'],
    );
  }

}
