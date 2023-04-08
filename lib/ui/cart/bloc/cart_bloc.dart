import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:nike_ecommerce_flutter/common/exceptions.dart';
import 'package:nike_ecommerce_flutter/data/CartResponse.dart';
import 'package:nike_ecommerce_flutter/data/authInfo.dart';
import 'package:nike_ecommerce_flutter/data/cartItem.dart';
import 'package:nike_ecommerce_flutter/data/repo/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final IcartRepository cartRepository;

  CartBloc(this.cartRepository) : super(CartLloading()) {
    on<CartEvent>((event, emit) async {
      try {
        emit(CartLloading());
        if (event is CartStarted) {
          final authInfo = event.authInfo;
          if (authInfo == null || authInfo.accessToken.isEmpty) {
            emit(CartAuthRequired());
          } else {
            final result = await cartRepository.getAll();
            emit(CartSuccess(result));
          }
        }
      } catch (error) {
        emit(CartError(error is AppException ? error : AppException()));
      }
    });
  }
}
