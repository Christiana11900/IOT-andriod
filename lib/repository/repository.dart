import 'package:dio/dio.dart';


class Repository {
  static String baseURL = 'https://api.thingspeak.com/channels/3067624/';

  static Future<Response> temp() {
    var url =
        '${baseURL}fields/1.json?results=10';
    Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    return dio.get(url);
  }

  static Future<Response> hum() {
    var url =
        '${baseURL}fields/2.json?results=10';
    Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    return dio.get(url);
  }

  static Future<Response> gas_level() {
    var url =
        '${baseURL}fields/3.json?results=10';
    Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    return dio.get(url);
  }

}