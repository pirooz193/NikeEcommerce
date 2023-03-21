import 'package:nike_ecommerce_flutter/common/http_client.dart';
import 'package:nike_ecommerce_flutter/data/banner.dart';
import 'package:nike_ecommerce_flutter/data/source/BannerDataSource.dart';

final bannerRepository = BannerRepository(BannerRemoteDataSource(httpClient));

abstract class IBannerrepository {
  Future<List<Banner>> getAll();
}

class BannerRepository implements IBannerrepository {
  final IBannerDataSource dataSource;

  BannerRepository(this.dataSource);
  @override
  Future<List<Banner>> getAll() {
    return dataSource.getAll();
  }
}
