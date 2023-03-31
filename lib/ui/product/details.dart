import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/product.dart';
import 'package:nike_ecommerce_flutter/data/repo/cart_repository.dart';
import 'package:nike_ecommerce_flutter/theme.dart';
import 'package:nike_ecommerce_flutter/ui/product/bloc/product_bloc.dart';
import 'package:nike_ecommerce_flutter/ui/product/comment/commentList.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/image.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  StreamSubscription<ProductState>? stateSubscribtion;

  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey();
  @override
  void dispose() {
    stateSubscribtion?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<ProductBloc>(
        create: (context) {
          final productBloc = ProductBloc(cartRepository);
          stateSubscribtion = productBloc.stream.listen((state) {
            if (state is ProductAddTocartSuccess) {
              scaffoldKey.currentState?.showSnackBar(const SnackBar(
                  content: Text('با موفقیت به سبد خرید شما اضافه شد')));
            } else if (state is ProductAddTocartError) {
              scaffoldKey.currentState?.showSnackBar(
                  SnackBar(content: Text(state.exception.message)));
            }
          });
          return productBloc;
        },
        child: ScaffoldMessenger(
          key: scaffoldKey,
          child: Scaffold(
            floatingActionButton: SizedBox(
              width: MediaQuery.of(context).size.width - 48,
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  return FloatingActionButton.extended(
                      onPressed: () {
                        BlocProvider.of<ProductBloc>(context)
                            .add(CartAddButtonClicked(widget.product.id));
                      },
                      label: state is ProductAddTocartButtonLoading
                          ? CupertinoActivityIndicator(
                              color: Theme.of(context).colorScheme.onSecondary,
                            )
                          : Text('افزودن به سبد خرید'));
                },
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: CustomScrollView(
              physics: defaultScrollPhysics,
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width * 0.8,
                  flexibleSpace: ImageLoadingService(
                    imageUrl: widget.product.imageAddress,
                  ),
                  foregroundColor: LightThemeColors.primaryTextColor,
                  actions: [
                    IconButton(
                        onPressed: () {}, icon: Icon(CupertinoIcons.heart))
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              widget.product.title,
                              style: Theme.of(context).textTheme.headline6,
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.product.previousPrice.withPriceLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .apply(
                                          decoration:
                                              TextDecoration.lineThrough),
                                ),
                                Text(widget.product.price.withPriceLabel),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text(
                          'این کفش شدیدا برای دویدن و راه رفتن مناسب است . تقریبا هیچ فشار مخربی به پا وارد نمی‌کند .',
                          style: TextStyle(height: 1.4),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'نظرات کاربران',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            TextButton(
                                onPressed: () {}, child: Text('ثبت نظر '))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                CommentList(productId: widget.product.id)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
