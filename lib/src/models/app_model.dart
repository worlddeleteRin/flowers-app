// import 'dart:core';

import 'package:dio/dio.dart';
import 'package:myapp/src/models/catalogue_model.dart';

import 'package:myapp/src/blocs/cart_bloc.dart';
import 'package:myapp/src/models/orders_model.dart';
import 'package:myapp/src/models/user_model.dart';

class SocialContact {
  String value = "";
  String label = "";
  String link = "";

  SocialContact({
    this.value = "",
    this.label = "",
    this.link = ""
  });

  factory SocialContact.fromJson(Map<String,dynamic> json) {
    return SocialContact(
      value: json["value"],
      label: json["label"],
      link: json["link"]
    );
  }

}

class CommonInfo {
  String location_address = "";
  String delivery_phone = "";
  String delivery_phone_display = "";
  String main_logo_link = "";
  String map_delivery_location_link = "";
  List<SocialContact> socials;

  CommonInfo({
    this.location_address = "",
    this.delivery_phone = "",
    this.delivery_phone_display = "",
    this.main_logo_link = "",
    this.map_delivery_location_link = "",
    required this.socials
  });

  factory CommonInfo.fromJson(Map<String,dynamic> json) {
    List<SocialContact> socialItems = json["socials"].map<SocialContact>(
      (social) => SocialContact.fromJson(social)
    ).toList();

    CommonInfo result = CommonInfo(
      location_address: json["location_address"],
      delivery_phone: json["delivery_phone"],
      delivery_phone_display: json["delivery_phone_display"],
      main_logo_link: json["main_logo_link"],
      map_delivery_location_link: json["map_delivery_location_link"],
      socials: socialItems,
    );

    print('result is ${result}');
    return result;
  }

  static CommonInfo? processFromResponse(Response response) {
    if (response.statusCode != 200) {return null; };
    try {
      CommonInfo? commonInfo = CommonInfo.fromJson(response.data);
      return commonInfo;
    } on Exception {
      return null;
    }
  }

}

class CheckoutFormInfo {
  DeliveryMethod? delivery_method;
  PaymentMethod? payment_method;
  PickupAddress? pickup_address;
  UserDeliveryAddress? delivery_address;
  String custom_message = '';
  String postcard_text = '';
  String recipient_type = 'user';
  DateTime? delivery_datetime;
  RecipientPerson recipient_person = RecipientPerson(
    name: "",
    phone: ""
  );

  bool isValid () {
    if (!(delivery_method is DeliveryMethod) ||
        !(payment_method is PaymentMethod) ||
        !(delivery_address is UserDeliveryAddress)) {
      return false;
    }
    return true;
  }
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
