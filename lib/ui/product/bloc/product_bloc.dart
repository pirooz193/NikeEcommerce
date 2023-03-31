import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/common/exceptions.dart';
import 'package:nike_ecommerce_flutter/data/repo/cart_repository.dart';
import 'package:nike_ecommerce_flutter/data/repo/productRepository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final IcartRepository cartRepository;

  ProductBloc(this.cartRepository) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      try {
        if (event is CartAddButtonClicked) {
          emit(ProductAddTocartButtonLoading());
          final result = await cartRepository.add(event.productId);
          emit(ProductAddTocartSuccess());
        }
      } catch (error) {
        emit(ProductAddTocartError(AppException()));
      }
    });
  }
}
