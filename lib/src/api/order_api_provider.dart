import 'dart:async';
//import 'dart:convert';

import 'package:myapp/src/api/api_client.dart';
import 'package:dio/dio.dart';

class OrderAPIProvider {
  Dio client = APIClient().loadDef();

  /// creates new order for logged in user
  Future<Response> createOrder({
    required String authToken,
    required String cart_id,
    required String payment_method,
    required String delivery_method,
    String? delivery_address, 
  }) async {
    print('run create new order');
    Map<String,dynamic> ordersData = {
      "delivery_method": delivery_method,
      "payment_method": payment_method,
      "cart_id": cart_id,
      "delivery_address": delivery_address,
    };
    print('orders data is $ordersData');
    Response response = await client.post(
      "/orders/",
      data: ordersData,
      options: Options(
        headers: {
          'authorization': 'Bearer $authToken'
        }
      )
    );
    return response;
  }

}
