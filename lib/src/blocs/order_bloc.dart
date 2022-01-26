
import 'package:dio/dio.dart';
import 'package:myapp/src/api/order_api_provider.dart';
import 'package:myapp/src/blocs/cart_bloc.dart';
import 'package:myapp/src/blocs/user_bloc.dart';
import 'package:myapp/src/models/app_model.dart';
import 'package:myapp/src/models/cart_model.dart';
import 'package:myapp/src/models/orders_model.dart';
import 'package:myapp/src/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

class OrderBloc {

  OrderAPIProvider orderAPIProvider = OrderAPIProvider();

  BehaviorSubject checkoutFormInfo = BehaviorSubject<CheckoutFormInfo>.seeded(
    CheckoutFormInfo()
  );

  Stream get checkoutFormInfoStream => checkoutFormInfo.stream;

  Future<bool> createOrder() async {
    print('run create order');
    String? authToken = userBloc.authTokenLastValue;
    // print('authToken is $authToken');
    User? user = userBloc.userLastValue;
    Cart? cart = cartBloc.cartLastValue;
    // print('user is ${user}');
    CheckoutFormInfo? checkoutForm = checkoutFormInfo.valueOrNull;
    if (!(authToken is String) ||
      !(user is User)) { 
      print('error with token');
      return false;
    };
    if (!(cart is Cart)) {return false;}
    if (cart.line_items.isEmpty) {return false;};
    if (!(checkoutForm is CheckoutFormInfo)) {return false;};

    PaymentMethod? payment_method = checkoutForm.payment_method;
    DeliveryMethod? delivery_method = checkoutForm.delivery_method;
    UserDeliveryAddress? delivery_address = checkoutForm.delivery_address;
    String custom_message = checkoutForm.custom_message;
    if (!(payment_method is PaymentMethod)) {return false;};
    if (!(delivery_method is DeliveryMethod)) {return false;};

    print('its ok, can create');

    Response response = await orderAPIProvider.createOrder(
      authToken: authToken,
      cart_id: cart.id,
      payment_method: payment_method.id,
      delivery_method: delivery_method.id,
      delivery_address: delivery_address?.id,
      custom_message: custom_message,
    );
    if (response.statusCode == 200) {
      processOrderCreatedResponse(response); 
      return true;
    }
    return false;
  }

  processOrderCreatedResponse(Response response) {
    if (response.statusCode != 200) { return;}
    cartBloc.fetchCart();
    userBloc.fetchUserMe();
    userBloc.fetchUserOrders();
  }

  dispose() {
  }
}

final orderBloc = OrderBloc();
