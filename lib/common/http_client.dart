import 'package:dio/dio.dart';
import 'package:nike_ecommerce_flutter/data/repo/authRepository.dart';

final httpClient = Dio(BaseOptions(
  baseUrl: 'http://expertdevelopers.ir/api/v1/',
))
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final authInfo = AuthRepository.authChangeNotifier.value;
      if (authInfo != null && authInfo.accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer ${authInfo.accessToken}';
      }

      handler.next(options);
    },
  ));


    
//  dio.options.headers['Access-Control-Allow-Origin'] = 'http://localhost:39869'