import 'package:dio/dio.dart';

class APIClient {
  String APIUrl = "http://0.0.0.0:8000";
  // String APIUrl = "https://api.rollsberi-food.ru";

  Dio loadDef() {
    Dio _dio = new Dio();
    _dio.options.baseUrl = APIUrl;
    _dio.options.headers = {
      "content-type": "application/json", 
      "App-Token": "some_access_token_is_here",
    };
    return _dio;
  }

}

