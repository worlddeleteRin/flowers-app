import 'package:myapp/src/api/user_api_provider.dart';
import 'package:myapp/src/models/orders_model.dart';
import 'package:myapp/src/models/user_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dio/dio.dart';


// import 'dart:convert';

class UserBloc {

  UserAPIProvider userAPIProvider = UserAPIProvider();

  final _authTokenFetcher = BehaviorSubject();
  final _userFetcher = BehaviorSubject<User>();
  final _userOrdersFetcher = BehaviorSubject();
  final _userDeliveryAddresses = 
  BehaviorSubject<List<UserDeliveryAddress>>();
  final userLoginForm = 
  BehaviorSubject<UserLoginForm>.seeded(UserLoginForm());


  Stream get authToken => _authTokenFetcher.stream;
  Stream<User> get user => _userFetcher.stream;
  Stream get userOrders => _userOrdersFetcher.stream;
  Stream get userDeliveryAddresses => _userDeliveryAddresses.stream;
  Stream get userLoginFormStream => userLoginForm.stream;

  User? get userLastValue => _userFetcher.valueOrNull;
  String? get authTokenLastValue => _authTokenFetcher.valueOrNull;
  List<UserDeliveryAddress>? get userDeliveryAddressesLastValue => _userDeliveryAddresses.valueOrNull;

  Sink<User> get userSink => _userFetcher.sink;

  bool get isUserAuthorizedNow {
    String? authToken = authTokenLastValue; 
    User? user = userLastValue;
    if (!(authToken is String) ||
    !(user is User)) {
      return false;
    }
    return true;
  }

  bool userFetched = false;
  bool userOrdersFetched = false;
  bool userDeliveryAddressesFetched = false;


  /// check, if auth token saved in `SharedPreferences`
  /// with key `authToken`
  /// If not saved previously - user was not logged in
  /// Assign it to `_authTokenFetcher`
  /// try to fetch user, if `authToken` exists
  /// if error occurred when fetching user `authToken`
  /// will be removed from `SharedPreferences` storage
  /// and `_authTokenFetcher`
  checkAuthTokenGetUser() async {
    print('run check auth token and get user');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool authToken_exists = prefs.containsKey("authToken");
    if (!authToken_exists) {
      return;
    }
    String? savedAuthToken = prefs.getString("authToken");
    if (!(savedAuthToken is String)) {return;};
    _authTokenFetcher.sink.add(savedAuthToken);
    User? user = await getUserMe();
    print('user is ${user}');
    if (!(user is User)) {
      prefs.remove("authToken");
    } else {
      _userFetcher.sink.add(user);
    }
  }

  Future<bool> loginForAccessToken(
    // required String username,
    // required String password,
  ) async {
    UserLoginForm? loginForm = userLoginForm.valueOrNull;
    if (!(loginForm is UserLoginForm)) {return false;};
    String? authToken = await loginGetAccessToken(
      loginForm: loginForm
    );
    if (authToken == null) { return false; }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _authTokenFetcher.sink.add(authToken);
    await prefs.setString("authToken", authToken);
    await fetchUserMe();
    User? user = _userFetcher.valueOrNull;
    if (user is User) {
      return true;
    }
    return false;
  }

  Future<bool> loginUser() async {
    UserLoginForm? loginForm = userLoginForm.valueOrNull;
    if (!(loginForm is UserLoginForm)) {return false;};
    try {
      Response response = await userAPIProvider.loginUser(
        username: loginForm.username,
        authType: loginForm.auth_type,
      );
      if (response.statusCode != 200) {return false;};
      return true;
    } on Exception {
      return false;
    }
  }

  logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); 
    await prefs.remove("authToken");
    _userFetcher.sink.addError(
      "user not logged in"
    );
    // _userFetcher.addError("some error");
    // _userFetcher.sink.close
    _authTokenFetcher.sink.add(null);
    // _userFetcher.close();
  }

  Future<String?> loginGetAccessToken({
    required UserLoginForm loginForm
  }) async  {
    Response response = await userAPIProvider.loginGetAccessToken(
      username: loginForm.username,
      password: loginForm.password, 
      otp: loginForm.otp,
      authType: loginForm.auth_type,
    );
    if (response.statusCode != 200) {return null;};
    Map<String,dynamic> responseData = response.data;
    if (!responseData.containsKey('access_token')) {return null;}
    String authToken = responseData['access_token'];
    return authToken;
  }

  /// call getUserMe, if user returns add it to 
  /// `_userFetcher`, or return null
  fetchUserMe() async {
    User? user = await getUserMe(); 
    if (!(user is User)) {
      return null;
    }
    print('add user to fetcer, user is $user');
    _userFetcher.sink.add(user);
  }

  fetchUserOrders() async {
    List<Order>? ordersList = await getUserOrders();
    this.userOrdersFetched = true;
    if (!(ordersList is List<Order>)) {return null;};
    _userOrdersFetcher.sink.add(ordersList);
  }

  fetchUserDeliveryAddresses() async {
    List<UserDeliveryAddress>? userAddresses = await getUserDeliveryAddresses();
    this.userDeliveryAddressesFetched = true;
    if (!(userAddresses is List<UserDeliveryAddress>)) {return null;};
    _userDeliveryAddresses.sink.add(userAddresses);
  }

  /// call api to get user, if `authToken` exists
  /// or return null 
  Future<User?> getUserMe() async {
    String? authToken = _authTokenFetcher.valueOrNull;
    if (authToken == null) {return null;};
    try {
      Response response = await userAPIProvider.getUserMe(
        authToken: _authTokenFetcher.value 
      );
      print('user response is $response');
      User? user = processUserFromResponse(response);
      return user;
    } on Exception {
      return null;
    }
  }

  /// updates passed user
  Future<bool> updateUserMe({
    required User currentUser
  }) async {
    String? authToken = _authTokenFetcher.valueOrNull;
    if (authToken == null) {return false;};
    try {
      Response response = await userAPIProvider.updateUserMe(
        authToken: _authTokenFetcher.value,
        user: currentUser,
      );
      print('user response is $response');
      User? user = processUserFromResponse(response);
      if (user is User) {
        _userFetcher.sink.add(user);
        return true;
      }
      return false;
    } on Exception {
      return false;
    }
  }

  /// call api to get user orders, 
  /// if `authToken` exists
  Future<List<Order>?> getUserOrders() async {
    String? authToken = _authTokenFetcher.valueOrNull;
    if (authToken == null) {return null;};
    try {
      Response response = await userAPIProvider.getUserOrders(
        authToken: _authTokenFetcher.value 
      );
      List<Order>? ordersList = processUserOrdersFromResponse(response);
      return ordersList;
    } on Exception {
      return null;
    }
  }

  /// call api to get user delivery addresses, 
  /// if `authToken` exists
  Future<List<UserDeliveryAddress>?> getUserDeliveryAddresses() async {
    String? authToken = authTokenLastValue;
    if (authToken == null) {return null;};
    try {
      Response response = await userAPIProvider.getUserDeliveryAddresses(
        authToken: authToken, 
      );
      List<UserDeliveryAddress>? userDeliveryAddresses = 
      UserDeliveryAddress.processAddressesFromResponse(response);
      return userDeliveryAddresses;
    } on Exception {
      return null;
    }
  }

  // update passed user [`address`]
  Future<bool> updateUserDeliveryAddress ({
    required UserDeliveryAddress address
  }) async {
    String? authToken = authTokenLastValue;
    if (authToken == null) {return false;};
    try {
      Response response = await userAPIProvider.updateUserDeliveryAddresses(
        authToken: authToken,
        address: address,
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on Exception {
      return false;
    }
  }

  Future<bool> deleteUserDeliveryAddress ({
    required String addressId
  }) async {
    String? authToken = authTokenLastValue;
    if (authToken == null) {return false;};
    try {
      Response response = await userAPIProvider.deleteUserDeliveryAddresses(
        authToken: authToken,
        addressId: addressId
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on Exception {
      return false;
    }
  }

  Future<bool> createUserDeliveryAddress ({
    required UserDeliveryAddress address
  }) async {
    String? authToken = authTokenLastValue;
    if (authToken == null) {return false;};
    try {
      Response response = await userAPIProvider.createUserDeliveryAddresses(
        authToken: authToken,
        address: address,
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on Exception {
      return false;
    }
  }

  
  /// process user orders from response
  /// return Orders list | null
  List<Order>? processUserOrdersFromResponse(Response response) {
    if (response.statusCode != 200) {return null;}
    try {
      List ordersRawList = response.data['orders'];
      print('orders raw list is $ordersRawList');
      List<Order> ordersList = ordersRawList.map<Order>(
      (orderItem) => Order.fromJson(orderItem)
      ).toList();
      return ordersList;
    } on Exception {
      return null;
    }
  }
  /// process user data from response
  /// returns User object | null
  User? processUserFromResponse(Response response) {
    if (response.statusCode != 200) {
      return null;
    }
    Map<String,dynamic> userData = response.data;
    User user = User.fromJson(userData);
    return user;
  }
  
  dispose() {
    _userFetcher.close();
    _authTokenFetcher.close();
  }

}

final userBloc = UserBloc();
