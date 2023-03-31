part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class CartAddButtonClicked extends ProductEvent {
  final int productId;

  CartAddButtonClicked(this.productId);
}
