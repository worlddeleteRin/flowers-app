import 'dart:async';
//import 'dart:convert';

import 'package:myapp/src/api/api_client.dart';
import 'package:dio/dio.dart';
import 'package:myapp/src/models/user_model.dart';

class UserAPIProvider {
  Dio client = APIClient().loadDef();

  /// send post request with `username` and `password` 
  /// to the server in FormData,
  /// expected to get `access_token` in resopnse, if
  /// login credentials are successfull
  Future<Response> loginUser({
    required String username, 
    required String authType
  }) async {
    print('run login user');
    /*
    FormData formData = FormData.fromMap({
      "username": username,
      "authentication_type": authType, 
    });
    */
    Map<String,dynamic> data = {
      "is_testing": true,
      "username": username,
      "authentication_type": authType,      
    };
    Response response = await client.post(
      "/users/login",
      data: data,
    );
    return response;
  }

  Future<Response> loginGetAccessToken({
    required String username, 
    required String password,
    required String otp,
    required String authType
  }) async {
    print('run login user to get access token');
    FormData formData = FormData.fromMap({
      "username": username,
      "password": password,
      "otp": otp,
      "auth_type": authType
    });
    Response response = await client.post(
      "/users/token",
      data: formData,
    );
    return response;
  }

  /// get new session id from api,
  /// returns it
  Future<Response> getUserMe({
    required String authToken,
  }) async {
    print('run get user me');
    Response response = await client.get(
      "/users/me",
      options: Options(
        headers: {
          'authorization': 'Bearer $authToken'
        }
      )
    );
    print('response is $response');
    return response;
  }

  /// update passed user,
  Future<Response> updateUserMe({
    required User user,
    required String authToken,
  }) async {
    print('run update user me');
    Response response = await client.patch(
      "/users/me",
      data: user.toJson(),
      options: Options(
        headers: {
          'authorization': 'Bearer $authToken'
        }
      )
    );
    print('response is $response');
    return response;
  }

  /// get orders for current user
  Future<Response> getUserOrders({
    required String authToken,
  }) async {
    print('run get user orders');
    Response response = await client.get(
      "/users/me/orders",
      options: Options(
        headers: {
          'authorization': 'Bearer $authToken'
        }
      )
    );
    return response;
  }

  /// get current user delivery addresses 
  Future<Response> getUserDeliveryAddresses({
    required String authToken,
  }) async {
    print('run get user delivery addresses');
    Response response = await client.get(
      "/users/me/delivery-address",
      options: Options(
        headers: {
          'authorization': 'Bearer $authToken'
        }
      )
    );
    return response;
  }

  /// create new user delivery addresses 
  Future<Response> createUserDeliveryAddresses({
    required String authToken,
    required UserDeliveryAddress address,
  }) async {
    print('run create user delivery addresses');
    Response response = await client.post(
      "/users/me/delivery-address",
      data: address.toJson(),
      options: Options(
        headers: {
          'authorization': 'Bearer $authToken'
        }
      )
    );
    print('response is ${response.data}');
    return response;
  }

  /// update user delivery addresses 
  /// with specified `[id]`
  Future<Response> updateUserDeliveryAddresses({
    required String authToken,
    required UserDeliveryAddress address,
  }) async {
    print('run get user delivery addresses');
    print('address id is ${address.id} ${address.street}');
    Response response = await client.patch(
      "/users/me/delivery-address/${address.id}",
      data: address.toJson(),
      options: Options(
        headers: {
          'authorization': 'Bearer $authToken'
        }
      )
    );
    return response;
  }

  /// delete user delivery addresses 
  /// with specified `[id]`
  Future<Response> deleteUserDeliveryAddresses({
    required String authToken,
    required String addressId,
  }) async {
    print('run delete user delivery addresses');
    Response response = await client.delete(
      "/users/me/delivery-address/${addressId}",
      options: Options(
        headers: {
          'authorization': 'Bearer $authToken'
        }
      )
    );
    return response;
  }

}
