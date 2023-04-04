import 'package:nike_ecommerce_flutter/common/http_client.dart';
import 'package:nike_ecommerce_flutter/data/CartResponse.dart';
import 'package:nike_ecommerce_flutter/data/cartItem.dart';
import 'package:nike_ecommerce_flutter/data/add_to_cart_response.dart';
import 'package:nike_ecommerce_flutter/data/source/cartdataSource.dart';

final cartRepository = CartRepository(CartRemoteDataSource(httpClient));

abstract class IcartRepository extends ICartDataSource {}

class CartRepository implements IcartRepository {
  final ICartDataSource dataSource;

  CartRepository(this.dataSource);
  @override
  Future<AddToCartResponse> add(int productId) {
    return dataSource.add(productId);
  }

  @override
  Future<AddToCartResponse> changeCount(int cartItemId, int count) {
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
  Future<CartResponse> getAll() {
    return dataSource.getAll();
  }
}
