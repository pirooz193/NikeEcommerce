part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartStarted extends CartEvent {
  final AuthInfo? authInfo;

  const CartStarted(this.authInfo);
}

class CartAuthInfoChanged extends CartEvent {
  final AuthInfo? authInfo;

  const CartAuthInfoChanged(this.authInfo);
}

class CartDeleteButtonClicked extends CartEvent {
  final int cartItemId;

  const CartDeleteButtonClicked(this.cartItemId);
}
