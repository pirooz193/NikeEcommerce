import 'package:nike_ecommerce_flutter/common/http_client.dart';
import 'package:nike_ecommerce_flutter/data/cartItem.dart';
import 'package:nike_ecommerce_flutter/data/cartResponse.dart';
import 'package:nike_ecommerce_flutter/data/source/cartdataSource.dart';

final cartRepository = CartRepository(CartRemoteDataSource(httpClient));

abstract class IcartRepository extends ICartDataSource {}

class CartRepository implements IcartRepository {
  final ICartDataSource dataSource;

  CartRepository(this.dataSource);
  @override
  Future<CartResponse> add(int productId) {
    return dataSource.add(productId);
  }

  @override
  Future<CartResponse> changeCount(int cartItemId, int count) {
    return dataSource.changeCount(cartItemId, count);
  }

  @override
  Future<int> count() {
    return dataSource.count();
  }

  @override
  Future<void> delete(int cartItemId) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<CartItemEntity>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }
}
