part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductAddTocartButtonLoading extends ProductState {}

class ProductAddTocartSuccess extends ProductState {}

class ProductAddTocartError extends ProductState {
  final AppException exception;

  const ProductAddTocartError(this.exception);
  @override
  // TODO: implement props
  List<Object> get props => [exception];
}
