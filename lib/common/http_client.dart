import 'package:dio/dio.dart';

final httpClient = Dio(BaseOptions(
  baseUrl: 'http://expertdevelopers.ir/api/v1/',
  headers: {
    'Access-Control-Allow-Origin': 'http://localhost:39869',
  },
));


    
//  dio.options.headers['Access-Control-Allow-Origin'] = 'http://localhost:39869'