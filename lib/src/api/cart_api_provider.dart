import 'dart:async';
import 'dart:convert';

import 'package:myapp/src/api/api_client.dart';
import 'package:dio/dio.dart';
import 'package:myapp/src/models/cart_model.dart';

class CartAPIProvider {
  //Client client = Client();
  // init dio client
  Dio client = APIClient().loadDef();

  /// get cart for [sessionId]
  Future getCart({
    required String sessionId,
  }) async {
    print('run get cart function');
    print('session id is $sessionId');
    Response response = await client.get(
      "/carts/$sessionId",
    );
    return response;
  }

  /// create cart for [sessionId] with [cartItems]
  Future createCart({
    required String sessionId,
    required List<Map> cartItems,
  }) async {
    print('run create cart function');
    String body = json.encode({
      "line_items": cartItems,
    });
    print('body is: ${body.toString()}');
    Response response = await client.post(
      "/carts/$sessionId",
      data: body,
    );
    return response;
  }

  /// add [cartItems] to cart with [cartId]
  Future addCartItems({
    required cartId,
    required List<Map> cartItems,
  }) async {
    print('run add cart items');
    String body = json.encode({
      "line_items": cartItems,
    });
    print('body is: ${body.toString()}');
    Response response = await client.post(
      "/carts/$cartId/items",
      data: body,
    );
    print('response is ${response.data.toString()}');
    return response;
  }

  /// remove cartItem with [itemId] from cart with [cartId]
  Future removeCartItem({
    required String cartId,
    required String itemId,
  }) async {
    print('run remove cart items');
    Response response = await client.delete(
      "/carts/$cartId/items/$itemId",
    );
    return response;
  }

  /// update cart [lineItem]
  Future updateCartItem({
    required String cartId,
    required LineItem lineItem,
  }) async {
    String data = json.encode({
      "line_item": lineItem.toJson(),
    });
    print('run update cart item');
    Response response = await client.patch(
      "/carts/$cartId/items/${lineItem.id}",
      data: data,
    );
    print('response is ${response.toString()}');
    return response;
  }

}
