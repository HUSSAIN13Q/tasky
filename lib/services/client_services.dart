import 'package:dio/dio.dart';

class Client {
  static final _baseUrl = 'http://167.71.7.159/api/tasky';
  static final Dio dio = Dio(BaseOptions(baseUrl: _baseUrl));
}
