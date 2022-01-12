import 'dart:async';
//import 'dart:convert';

import 'package:myapp/src/api/api_client.dart';
import 'package:dio/dio.dart';

class UserAPIProvider {
  Dio client = APIClient().loadDef();

  /// send post request with `username` and `password` 
  /// to the server in FormData,
  /// expected to get `access_token` in resopnse, if
  /// login credentials are successfull
  Future<Response> loginGetAccessToken({
    required String username, 
    required String password
  }) async {
    print('run login user to get access token');
    FormData formData = FormData.fromMap({
      "username": username,
      "password": password
    });
    Response response = await client.post(
      "/users/me",
      data: formData,
    );
    return response;
  }

  /// get new session id from api,
  /// returns it
  Future<Response> getUserMe({
    required String authToken
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
    return response;
  }

}
