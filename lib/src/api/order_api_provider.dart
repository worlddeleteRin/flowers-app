import 'dart:async';
//import 'dart:convert';

import 'package:myapp/src/api/api_client.dart';
import 'package:dio/dio.dart';
import 'package:myapp/src/models/user_model.dart';

class OrderAPIProvider {
  Dio client = APIClient().loadDef();

  /// creates new order for logged in user
  Future<Response> createOrder({
    required String authToken,
    required String cart_id,
    required String payment_method,
    required String delivery_method,
    String custom_message = '',
    String postcard_text = '',
    String? delivery_address, 
    String? recipient_type,
    DateTime? delivery_datetime,
    RecipientPerson? recipient_person
  }) async {
    print('run create new order');
    Map<String,dynamic> ordersData = {
      "delivery_method": delivery_method,
      "payment_method": payment_method,
      "cart_id": cart_id,
      "delivery_address": delivery_address,
      "custom_message": custom_message,
      "postcard_text": postcard_text,
      "recipient_type": recipient_type,
      "delivery_datetime": delivery_datetime == null ?
      null: delivery_datetime.toString(),
      "recipient_person": recipient_person,
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

  Future<Response> getOrderById({
    required String authToken,
    required String orderId
  }) async {
    Response response = await client.get(
      "/orders/${orderId}",
      options: Options(
        headers: {
          'authorization': 'Bearer $authToken'
        }
      )
    );
    return response;
  }

}
