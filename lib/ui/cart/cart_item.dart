import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/cartItem.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/image.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
    required this.data,
    required this.onDeleteButtonClicked,
  }) : super(key: key);

  final CartItemEntity data;
  final GestureTapCallback onDeleteButtonClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.05))
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: ImageLoadingService(
                      borderRadius: BorderRadius.circular(12),
                      imageUrl: data.product.imageAddress),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data.product.title,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('تعداد'),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.plus_rectangle),
                        ),
                        Text(
                          data.count.toString(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.minus_rectangle),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.product.previousPrice.withPriceLabel,
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough),
                    ),
                    Text(data.product.price.withPriceLabel)
                  ],
                )
              ],
            ),
          ),
          const Divider(
            height: 1,
          ),
          data.deleteButtonLoading
              ? const SizedBox(
                  height: 48,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                )
              : TextButton(
                  onPressed: onDeleteButtonClicked,
                  child: const Text('حذف از سبد خرید'),
                ),
        ],
      ),
    );
  }
}
