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

}
