// import 'dart:core';

//import 'package:myapp/src/models/catalogue_model.dart';
// import 'package:myapp/src/blocs/cart_bloc.dart';

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
