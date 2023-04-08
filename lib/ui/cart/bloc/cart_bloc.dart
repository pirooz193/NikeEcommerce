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
      if (event is CartStarted) {
        final authInfo = event.authInfo;
        if (authInfo == null || authInfo.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          await loadCartItems(emit);
        }
      } else if (event is CartDeleteButton) {
      } else if (event is CartAuthInfoChanged) {
        if (event.authInfo == null || event.authInfo!.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          if (state is CartAuthRequired) {
            await loadCartItems(emit);
          }
        }
      }
    });
  }

  Future<void> loadCartItems(Emitter<CartState> emit) async {
    try {
      emit(CartLloading());
      final result = await cartRepository.getAll();
      if (result.cartItems.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartSuccess(result));
      }
    } catch (e) {
      emit(CartError(AppException()));
    }
  }
}
