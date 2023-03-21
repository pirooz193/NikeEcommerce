import 'package:nike_ecommerce_flutter/common/http_client.dart';
import 'package:nike_ecommerce_flutter/data/banner.dart';
import 'package:nike_ecommerce_flutter/data/source/BannerDataSource.dart';

final bannerRepository = BannerRepository(BannerRemoteDataSource(httpClient));

abstract class IBannerrepository {
  Future<List<BannerEntity>> getAll();
}

class BannerRepository implements IBannerrepository {
  final IBannerDataSource dataSource;

  BannerRepository(this.dataSource);
  @override
  Future<List<BannerEntity>> getAll() {
    return dataSource.getAll();
  }
}
