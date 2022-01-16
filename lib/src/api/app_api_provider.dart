import 'dart:async';
//import 'dart:convert';

import 'package:myapp/src/api/api_client.dart';
import 'package:dio/dio.dart';

class AppAPIProvider {
  Dio client = APIClient().loadDef();

  /// get new session id from api,
  /// returns it
  Future<String> getSessionId() async {
    print('run get session id');
    Response response = await client.get(
      "/session"
    );
    return response.data["session_id"];
  }

  Future getStocks() async {
    print('run get stocks');
    Response response = await client.get(
      "/site/stocks"
    );
    return response.data["stocks"];
  }

  Future<Response> getCheckoutInfo() async {
    print('run get checkout info');
    Response response = await client.get(
      "/site/checkout-common-info"
    );
    return response;
  }

}
