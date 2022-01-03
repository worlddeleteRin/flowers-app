import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/app_api_provider.dart';

import 'package:dio/dio.dart';


// import 'dart:convert';

class AppBloc {

  AppAPIProvider appAPIProvider = AppAPIProvider();

  BehaviorSubject _sessionIdFetcher = BehaviorSubject();

  Stream get sessionId => _sessionIdFetcher.stream;
  dynamic get sessionIdValue => _sessionIdFetcher.value;


  /// check, if session id saved in `SharedPreferences`
  /// with key `sessionId`. If not saved previously, call
  /// `createSessionId`.
  /// Assign it to `_sessionIdFetcher`
  checkGetSessionId () async {
    print('run check get session id');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool sessionId_exist = prefs.containsKey("sessionId");
    if (sessionId_exist) {
      print('session id exist');
      String? saved_sessionId = prefs.getString("sessionId");
      _sessionIdFetcher.sink.add(saved_sessionId);
    } else {
      print('session id not exist');
      String new_sessionId = await createSessionId();
      print('new session id is $new_sessionId');
      prefs.setString("sessionId", new_sessionId);
    }
  }

  /// call api method to create session id
  /// add created session id to `_sessionIdFetcher`
  Future<String> createSessionId () async {
    try {
      String response_sessionId = await appAPIProvider.getSessionId();
      _sessionIdFetcher.sink.add(response_sessionId);
      return response_sessionId;
    } on Exception {
      throw Exception();
    }
  }

  dispose() {
    _sessionIdFetcher.close();
  }

}

final appBloc = AppBloc();
