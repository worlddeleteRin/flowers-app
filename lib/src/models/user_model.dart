// import 'dart:core';

//import 'package:myapp/src/models/catalogue_model.dart';
// import 'package:myapp/src/blocs/cart_bloc.dart';

import 'package:dio/dio.dart';

class UserLoginForm {
  String username; 
  String password;
  String otp;
  String auth_type;

  UserLoginForm({
    this.username = "",
    this.password = "",
    this.otp = "",
    this.auth_type = "call_otp"
  });

}

class UserDeliveryAddress {
  String id;
  String city;
  String street;
  String house_number;
  String flat_number;
  String entrance_number;
  String floor_number;
  String address_display;
  String comment;

  UserDeliveryAddress({
    this.id = "",
    this.city = "",
    this.street = "",
    this.house_number = "",
    this.flat_number = "",
    this.entrance_number = "",
    this.floor_number = "",
    this.address_display = "",
    this.comment = "",
  });

  factory UserDeliveryAddress.fromJson(Map<String,dynamic> json) {
    return UserDeliveryAddress(
      id: json['id'], 
      city: json['city'], 
      street: json['street'], 
      house_number: json['house_number'], 
      flat_number: json['flat_number'], 
      entrance_number: json['entrance_number'], 
      floor_number: json['floor_number'], 
      address_display: json['address_display'], 
      comment: json['comment'], 
    );
  }
  
  Map<String,dynamic> toJson () =>
    {
      "id": this.id,
      "city": this.city,
      "street": this.street,
      "house_number": this.house_number,
      "flat_number": this.flat_number,
      "entrance_number": this.entrance_number,
      "floor_number": this.floor_number,
      "address_display": this.address_display,
      "comment": this.comment
    };

  static List<UserDeliveryAddress>? 
  processAddressesFromResponse (Response response) {
    if (response.statusCode != 200) {return null;};
    try {
      List<UserDeliveryAddress>? userDeliveryAddresses = 
      response.data.map<UserDeliveryAddress>((addressItem) =>
        UserDeliveryAddress.fromJson(addressItem)
      ).toList();
      return userDeliveryAddresses;
    } on Exception {
      return null;
    }
  }
}

class User {
  String id;
  String date_created;
  String email;
  String username;
  bool is_active;
  bool is_superuser;
  bool is_verified;
  String name;
  int bonuses;
  int bonuses_rank;

  User({
    required this.id,
    required this.date_created,
    this.email = "",
    required this.username,
    required this.is_active,
    required this.is_superuser,
    required this.is_verified,
    required this.name,
    required this.bonuses,
    required this.bonuses_rank,
  });

  factory User.fromJson(Map<String,dynamic> json) {

    return User(
      id: json['id'],
      date_created: json['date_created'],
      email: json['email'],
      username: json['username'],
      is_active: json['is_active'],
      is_superuser: json['is_superuser'],
      is_verified: json['is_verified'],
      name: json['name'],
      bonuses: json['bonuses'],
      bonuses_rank: json['bonuses_rank'],
    );
  }

}
