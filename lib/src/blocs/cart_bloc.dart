import 'package:myapp/src/models/catalogue_model.dart';
import 'package:rxdart/rxdart.dart';
import '../api/cart_api_provider.dart';

import 'package:myapp/src/models/cart_model.dart';
// import 'dart:convert';
import 'package:myapp/src/blocs/app_bloc.dart';

import 'package:dio/dio.dart';


class CartBloc {
  CartAPIProvider cartAPIProvider = CartAPIProvider();

  BehaviorSubject _cartFetcher = BehaviorSubject();

  Stream get cart => _cartFetcher.stream;

  /// fetch cart from api for `sessionId`
  fetchCart() async {
    String sessionId = appBloc.sessionIdValue;
    try {
      Response response = await cartAPIProvider.getCart(
        sessionId: sessionId,
      );
      processCartFromResponse(response);
    } on Exception {
      return Exception();
    }
  }

  /// create cart for current `sessionId`
  /// with [cartItems]
  createCart({
    required List<Map> cartItems,
  }) async {
    String sessionId = appBloc.sessionIdValue;
    Response response = await cartAPIProvider.createCart(
      sessionId: sessionId,
      cartItems: cartItems,
    );
    // print("created cart, response is ${response.data.toString()}");
    processCartFromResponse(response);
  }

  /// add [lineItem] to cart, assign new cart from response
  addCartItems({
    required String productId,
  }) async {
    print('run add cart items');
    Map<String, dynamic> lineItem = {
      "product_id": productId,
      "quantity": 1,
    };
    // print('line item is ${lineItem.toString()}');
    if (_cartFetcher.hasValue & (_cartFetcher.valueOrNull is Cart)) {
      // print('cart fetcher value is ${_cartFetcher.valueOrNull}');
      Cart cart = _cartFetcher.value;
      // print('cart fetcher has value: ${_cartFetcher.value}');
      Response response = await cartAPIProvider.addCartItems(
        cartId: cart.id,
        cartItems: [lineItem],
      );
      processCartFromResponse(response);
    } else {
      print('need to run create cart');
      await createCart(
        cartItems: [lineItem],
      );
    }
  }

  /// remove cartItem with [itemId] from cart
  removeCartItem({
    required String itemId,
  }) async {
    print('run remove cart item');
    if (_cartFetcher.hasValue & (_cartFetcher.valueOrNull is Cart)) {
      Cart cart = _cartFetcher.value;
      // print('cart fetcher has value: ${_cartFetcher.value}');
      Response response = await cartAPIProvider.removeCartItem(
        cartId: cart.id,
        itemId: itemId,
      );
      processCartFromResponse(response);
    } 
  }

  /// update cartItem with passed [lineItem]
  updateCartItem({
    required LineItem lineItem,
  }) async {
    print('run update cart item');
    if (_cartFetcher.hasValue & (_cartFetcher.valueOrNull is Cart)) {
      Cart cart = _cartFetcher.value;
      // print('cart fetcher has value: ${_cartFetcher.value}');
      Response response = await cartAPIProvider.updateCartItem(
        cartId: cart.id,
        lineItem: lineItem,
      );
      processCartFromResponse(response);
    } 
  }

  /// process cart from response, assign to `_cartFetcher`
  /// assign only if `response.statusCode == 200`
  processCartFromResponse(Response response) {
    if (response.statusCode != 200) {
      return null;
    }
    Map<String,dynamic> data = response.data;
    Cart cart = new Cart.fromJson(data);
    _cartFetcher.sink.add(cart);
  }

  dispose() {
    _cartFetcher.close();
  }
}

final cartBloc = CartBloc();
