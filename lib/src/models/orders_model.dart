import 'package:dio/dio.dart';
import 'package:myapp/src/models/cart_model.dart';
import 'package:myapp/src/models/common_model.dart';
import 'package:myapp/src/models/user_model.dart';


class CheckoutInfo {
  List <DeliveryMethod> delivery_methods;   
  List <PaymentMethod> payment_methods;
  List <PickupAddress> pickup_addresses;

  CheckoutInfo({
    required this.delivery_methods,
    required this.payment_methods,
    required this.pickup_addresses,
  });

  factory CheckoutInfo.fromJson(Map<String,dynamic> json) {
    List<DeliveryMethod> checkoutDeliveryMethods = 
    json['delivery_methods'].map<DeliveryMethod>((item) => 
    DeliveryMethod.fromJson(item)).toList();

    List<PaymentMethod> checkoutPaymentMethods = 
    json['payment_methods'].map<PaymentMethod>((item) => 
    PaymentMethod.fromJson(item)).toList();

    List<PickupAddress> checkoutPickupAddresses = 
    json['pickup_addresses'].map<PickupAddress>((item) => 
    PickupAddress.fromJson(item)).toList();

    return CheckoutInfo(
      delivery_methods: checkoutDeliveryMethods,
      payment_methods: checkoutPaymentMethods,
      pickup_addresses: checkoutPickupAddresses,
    );
  }

  static CheckoutInfo? processFromResponse (Response response) {
    if (response.statusCode != 200) { return null;}    
    try {
      CheckoutInfo checkoutInfo = CheckoutInfo.fromJson(response.data);
      return checkoutInfo;
    } on Exception {
      return null; 
    }
  }

}

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
  String info;

  PickupAddress({
    required this.id,
    required this.name,
    required this.info
  });
  factory PickupAddress.fromJson(Map<String,dynamic> json) {
    return PickupAddress(
      id: json['id'],
      name: json['name'],
      info: json['info']
    );
  }
}

class Order {
  String id;
  Cart cart;
  OrderStatus status;
  DateTime? date_created;
  DateTime? date_modified;
  DateTime? delivery_datetime;
  PaymentMethod payment_method;
  DeliveryMethod delivery_method;
  UserDeliveryAddress? delivery_address;
  PickupAddress? pickup_address;
  String custom_message;
  String postcard_text = "";
  String recipient_type;
  RecipientPerson? recipient_person;

  Order({
    required this.id,
    required this.cart,
    required this.status,
    required this.date_created,    
    required this.date_modified,
    required this.payment_method,
    required this.delivery_method,
    required this.delivery_datetime,
    this.delivery_address,
    this.pickup_address,
    required this.custom_message,
    this.postcard_text = "",
    this.recipient_type = RecipientTypes.user,
    this.recipient_person,
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

    RecipientPerson? recipientPerson = 
    json['recipient_person'] == null ?
    null :
    RecipientPerson.fromJson(json['recipient_person']);

    UserDeliveryAddress? orderDeliveryAddress = 
    json['delivery_address'] == null ?
    null:
    UserDeliveryAddress.fromJson(json['delivery_address']);

    PickupAddress? orderPickupAddress = 
    json['pickup_address'] == null ?
    null:
    PickupAddress.fromJson( json['pickup_address']);

    DateTime? delivery_datetime = 
    (json['delivery_datetime'] is String) ?
    DateTime.tryParse(json['delivery_datetime']):
    null;

    return Order(
      id: json['id'],
      cart: orderCart, 
      status: orderStatus,
      date_created: DateTime.tryParse(json['date_created']),
      date_modified: DateTime.tryParse(json['date_modified']),
      delivery_datetime: delivery_datetime,
      payment_method: orderPaymentMethod,
      delivery_method: orderDeliveryMethod,
      delivery_address: orderDeliveryAddress,
      pickup_address: orderPickupAddress,
      custom_message: json['custom_message'],
      postcard_text: json['postcard_text'],
      recipient_type: json['recipient_type'],
      recipient_person: recipientPerson,
    );
  }

  static Order? processOrderFromResponse(Response response) {
      if (response.statusCode != 200) { return null;};
      try {
        Order order = Order.fromJson(response.data);
        print('order is ${order}');
        return order;
      } on Exception {
        return null;
      }
  } 

}
