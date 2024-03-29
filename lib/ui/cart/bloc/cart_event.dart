part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartStarted extends CartEvent {
  final AuthInfo? authInfo;
  final bool isRefreshing;

  const CartStarted(this.authInfo, {this.isRefreshing = false});
}

class CartAuthInfoChanged extends CartEvent {
  final AuthInfo? authInfo;

  const CartAuthInfoChanged(this.authInfo);
}

class CartDeleteButtonClicked extends CartEvent {
  final int cartItemId;

  const CartDeleteButtonClicked(this.cartItemId);
}

class IncreaseButtonClicked extends CartEvent {
  final int cartItemId;

  const IncreaseButtonClicked(this.cartItemId);
}

class DecreaseButtonClicked extends CartEvent {
  final int cartItemId;

  const DecreaseButtonClicked(this.cartItemId);
}
