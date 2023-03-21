import 'package:dio/dio.dart';
import 'package:nike_ecommerce_flutter/data/banner.dart';
import 'package:nike_ecommerce_flutter/data/common/http_response_validator.dart';

abstract class IBannerDataSource {
  Future<List<Banner>> getAll();
}

class BannerRemoteDataSource
    with HttpResponseValidator
    implements IBannerDataSource {
  final Dio httpClient;

  BannerRemoteDataSource(this.httpClient);

  @override
  Future<List<Banner>> getAll() async {
    final response = await httpClient.get('banner/slider');
    validateResponse(response);
    final banners = <Banner>[];
    (response.data as List).forEach((element) {
      banners.add(Banner.fromJson(element));
    });
    return banners;
  }
}
