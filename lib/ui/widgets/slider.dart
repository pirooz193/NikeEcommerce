import 'package:flutter/widgets.dart';
import 'package:nike_ecommerce_flutter/data/banner.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/image.dart';

class BannerSlider extends StatelessWidget {
  final List<BannerEntity> banners;
  const BannerSlider({
    Key? key,
    required this.banners,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (context, index) => ImageLoadingService(
          imageUrl: banners[index].imageUrl,
        ),
      ),
    );
  }
}
