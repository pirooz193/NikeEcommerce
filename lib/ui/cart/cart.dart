import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/cartItem.dart';
import 'package:nike_ecommerce_flutter/data/repo/authRepository.dart';
import 'package:nike_ecommerce_flutter/data/repo/cart_repository.dart';
import 'package:nike_ecommerce_flutter/ui/auth/auth.dart';
import 'package:nike_ecommerce_flutter/ui/cart/bloc/cart_bloc.dart';
import 'package:nike_ecommerce_flutter/ui/cart/cart_item.dart';
import 'package:nike_ecommerce_flutter/ui/cart/price_info.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/empty_state.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? cartBloc;
  final RefreshController _refreshController = RefreshController();
  StreamSubscription? stateSubscribtion;
  bool stateIsSuccess = false;

  @override
  void initState() {
    super.initState();
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
  }

  void authChangeNotifierListener() {
    cartBloc!.add(CartAuthInfoChanged(AuthRepository.authChangeNotifier.value));
  }

  @override
  void dispose() {
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    cartBloc?.close();
    stateSubscribtion?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
          visible: stateIsSuccess,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 48, right: 48),
            child: FloatingActionButton.extended(
                onPressed: () {}, label: const Text('ثبت خرید')),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('سبد خرید'),
        ),
        body: BlocProvider<CartBloc>(
          create: (context) {
            final bloc = CartBloc(cartRepository);
            cartBloc = bloc;
            bloc.add(CartStarted(AuthRepository.authChangeNotifier.value));
            stateSubscribtion = bloc.stream.listen((state) {
              setState(() {
                stateIsSuccess = state is CartSuccess;
              });
              if (_refreshController.isRefresh) {
                if (state is CartSuccess) {
                  _refreshController.refreshCompleted();
                } else if (state is CartError) {
                  _refreshController.refreshFailed();
                }
              }
            });
            return bloc;
          },
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CartError) {
                return Center(
                  child: Text(state.exception.message),
                );
              } else if (state is CartSuccess) {
                return SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () {
                    cartBloc?.add(
                        CartStarted(AuthRepository.authChangeNotifier.value));
                  },
                  header: const ClassicHeader(
                    releaseText: 'رها کنید',
                    completeText: 'با موفقیت انجام شد',
                    refreshingText: 'در حال بروزرسانی',
                    idleText: 'برای بروزرسانی پایین بکشید',
                    failedText: 'خطای نامشخص',
                    spacing: 2,
                    completeIcon: Icon(
                      CupertinoIcons.check_mark_circled,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 80),
                    itemBuilder: (context, index) {
                      if (index < state.cartResponse.cartItems.length) {
                        final data = state.cartResponse.cartItems[index];
                        return CartItem(
                          data: data,
                          onDeleteButtonClicked: () {
                            cartBloc?.add(CartDeleteButtonClicked(data.id));
                          },
                          onIncreaseButtonClicked: () {
                            cartBloc?.add(IncreaseButtonClicked(data.id));
                          },
                          onDecreaseButtonClicked: () {
                            if (data.count > 1) {
                              cartBloc?.add(DecreaseButtonClicked(data.id));
                            }
                          },
                        );
                      } else {
                        return PriceInfo(
                            payablePrice: state.cartResponse.payablePrice,
                            shippingPrice: state.cartResponse.shippingCost,
                            totalPrice: state.cartResponse.totalPrice);
                      }
                    },
                    itemCount: state.cartResponse.cartItems.length + 1,
                  ),
                );
              } else if (state is CartAuthRequired) {
                return Center(
                  child: EmptyView(
                      message:
                          'برای مشاهده‌ی سبد خرید، ابتدا وارد حساب کاربری خود شوید.',
                      callToAction: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                              builder: (context) => const AuthScreen(),
                            ));
                          },
                          child: Text('ورود به حساب کاربری')),
                      image: SvgPicture.asset(
                        'assets/img/auth_required.svg',
                        width: 140,
                      )),
                );
              } else if (state is CartEmpty) {
                return Center(
                  child: EmptyView(
                    message:
                        'تا کنون هیچی محصولی به سبد خرید خود اضافه نکرده اید',
                    image: SvgPicture.asset(
                      'assets/img/empty_cart.svg',
                      width: 200,
                    ),
                  ),
                );
              } else {
                throw Exception('current state is not valid');
              }
            },
          ),
        ));

    //   ValueListenableBuilder<AuthInfo?>(
    //     valueListenable: AuthRepository.authChangeNotifier,
    //     builder: (context, authState, child) {
    //       bool isAuthenticated =
    //           authState != null && authState!.accessToken.isNotEmpty;
    //       return SizedBox(
    //         width: MediaQuery.of(context).size.width,
    //         child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Text(isAuthenticated
    //                   ? 'خوش آمدید'
    //                   : 'لطفا وارد حساب کاربری خود شوید'),
    //               isAuthenticated
    //                   ? ElevatedButton(
    //                       onPressed: () {
    //                         authRepository.signOut();
    //                       },
    //                       child: Text('خروج از حساب کاربری'))
    //                   : ElevatedButton(
    //                       onPressed: () {
    //                         Navigator.of(context, rootNavigator: true)
    //                             .push(MaterialPageRoute(
    //                           builder: (context) => const AuthScreen(),
    //                         ));
    //                       },
    //                       child: Text('ورود')),
    //               ElevatedButton(
    //                   onPressed: () async {
    //                     authRepository.refreshToken();
    //                   },
    //                   child: Text('Refresh Token'))
    //             ]),
    //       );
    //     },
    //   ),
    // );
  }
}
