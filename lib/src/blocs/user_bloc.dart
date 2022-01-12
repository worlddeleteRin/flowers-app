import 'package:myapp/src/api/user_api_provider.dart';
import 'package:myapp/src/models/user_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dio/dio.dart';


// import 'dart:convert';

class UserBloc {

  UserAPIProvider userAPIProvider = UserAPIProvider();

  BehaviorSubject _authTokenFetcher = BehaviorSubject();
  BehaviorSubject _userFetcher = BehaviorSubject();
  BehaviorSubject loginFormUsername = BehaviorSubject();

  Stream get authToken => _authTokenFetcher.stream;
  Stream get user => _userFetcher.stream;
  Stream get loginFormUsernameStream => loginFormUsername.stream;

  bool userFetched = false;

  /// check, if auth token saved in `SharedPreferences`
  /// with key `authToken`
  /// If not saved previously - user was not logged in
  /// Assign it to `_authTokenFetcher`
  checkAuthTokenGetUser() async {
    print('run check auth token and get user');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool authToken_exists = prefs.containsKey("authToken");
    if (!authToken_exists) {
      return;
    }
    String? savedAuthToken = prefs.getString("authToken");
    _authTokenFetcher.sink.add(savedAuthToken);
      // _sessionIdFetcher.sink.add(saved_sessionId);
  }

  loginUser({
    required String username,
    required String password,
  }) async {
    String? authToken = await loginGetAccessToken(
      username: username,
      password: password,
    );
    if (authToken == null) { return; }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _authTokenFetcher.sink.add(authToken);
    await prefs.setString("authToken", authToken);
    await fetchUserMe();
  }

  Future<String?> loginGetAccessToken({
    required String username,
    required String password,
  }) async  {
    Response response = await userAPIProvider.loginGetAccessToken(
      username: username,
      password: password
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
    _userFetcher.sink.add(user);
  }

  /// call api to get user, if `authToken` exists
  /// or return null 
  Future<User?> getUserMe() async {
    String? authToken = _authTokenFetcher.valueOrNull;
    if (authToken == null) {return null;};
    Response response = await userAPIProvider.getUserMe(
      authToken: _authTokenFetcher.value 
    );
    User? user = processUserFromResponse(response);
    return user;
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
