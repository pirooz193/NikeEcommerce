import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class ImageLoadingService extends StatelessWidget {
  final String imageUrl;
  final BorderRadius? borderRadius;
  const ImageLoadingService({
    Key? key,
    required this.imageUrl,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: CachedNetworkImage(imageUrl: imageUrl),
      borderRadius: borderRadius,
    );
  }
}
