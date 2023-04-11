import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/theme.dart';

class PriceInfo extends StatelessWidget {
  final int payablePrice;
  final int shippingPrice;
  final int totalPrice;

  const PriceInfo(
      {super.key,
      required this.payablePrice,
      required this.shippingPrice,
      required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 8, 0),
          child: Text(
            'جزئیات خرید',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(8, 8, 8, 32),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.1))
              ]),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('مبلغ کل خرید'),
                    RichText(
                      text: TextSpan(
                          text: totalPrice.seprateByComma,
                          style: DefaultTextStyle.of(context)
                              .style
                              .apply(color: LightThemeColors.primaryTextColor),
                          children: [
                            TextSpan(
                                text: ' تومان', style: TextStyle(fontSize: 10))
                          ]),
                    )
                  ],
                ),
              ),
              Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('هزینه ارسال'),
                    Text(shippingPrice.withPriceLabel),
                  ],
                ),
              ),
              Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('مبلغ قابل پرداخت'),
                    RichText(
                      text: TextSpan(
                        text: payablePrice.seprateByComma,
                        style: DefaultTextStyle.of(context).style.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        children: const [
                          TextSpan(
                            text: ' تومان',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                height: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
