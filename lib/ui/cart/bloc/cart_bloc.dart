import 'dart:math';

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

  CartBloc(this.cartRepository) : super(CartLoading()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStarted) {
        final authInfo = event.authInfo;
        if (authInfo == null || authInfo.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          await loadCartItems(emit, event.isRefreshing);
        }
      } else if (event is CartDeleteButtonClicked) {
        try {
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            final cartItem = successState.cartResponse.cartItems
                .firstWhere((element) => element.id == event.cartItemId);
            cartItem.deleteButtonLoading = true;
            emit(CartSuccess(successState.cartResponse));
          }
          await Future.delayed(Duration(microseconds: 500));
          await cartRepository.delete(event.cartItemId);
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            successState.cartResponse.cartItems
                .removeWhere((element) => element.id == event.cartItemId);
            if (successState.cartResponse.cartItems.isEmpty) emit(CartEmpty());
            emit(calculatePriceIfo(successState.cartResponse));
          }
        } catch (e) {}
      } else if (event is CartAuthInfoChanged) {
        if (event.authInfo == null || event.authInfo!.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          if (state is CartAuthRequired) {
            await loadCartItems(emit, false);
          }
        }
      } else if (event is IncreaseButtonClicked ||
          event is DecreaseButtonClicked) {
        try {
          int cartItemId = 0;
          if (event is IncreaseButtonClicked) {
            cartItemId = event.cartItemId;
          } else if (event is DecreaseButtonClicked) {
            cartItemId = event.cartItemId;
          }
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            final cartItem = successState.cartResponse.cartItems
                .indexWhere((element) => element.id == cartItemId);
            successState.cartResponse.cartItems[cartItem].changeCountLoading =
                false;
            emit(CartSuccess(successState.cartResponse));

            await Future.delayed(const Duration(microseconds: 500));
            final newCount = event is IncreaseButtonClicked
                ? ++successState.cartResponse.cartItems[cartItem].count
                : --successState.cartResponse.cartItems[cartItem].count;
            successState.cartResponse.cartItems[cartItem].count = newCount;
            await cartRepository.changeCount(cartItemId, newCount);

            emit(calculatePriceIfo(successState.cartResponse));
          }
        } catch (e) {}
      }
    });
  }

  Future<void> loadCartItems(Emitter<CartState> emit, bool isRefreshing) async {
    try {
      if (!isRefreshing) {
        emit(CartLoading());
      }

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

  CartSuccess calculatePriceIfo(CartResponse cartResponse) {
    int totalPrice = 0;
    int shippingCost = 0;
    int payablePrice = 0;

    cartResponse.cartItems.forEach((cartItem) {
      totalPrice += cartItem.product.previousPrice * cartItem.count;
      payablePrice += cartItem.product.price * cartItem.count;
    });

    shippingCost = payablePrice >= 250000 ? 0 : 30000;
    cartResponse.totalPrice = totalPrice;
    cartResponse.payablePrice = payablePrice;
    cartResponse.shippingCost = shippingCost;
    return CartSuccess(cartResponse);
  }
}
