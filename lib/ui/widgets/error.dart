import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nike_ecommerce_flutter/common/exceptions.dart';

class AppErrorWidget extends StatelessWidget {
  final AppException exception;
  final GestureTapCallback onTap;
  const AppErrorWidget({
    Key? key,
    required this.exception,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(exception.message),
            ElevatedButton(onPressed: onTap, child: Text('تلاش دوباره'))
          ]),
    );
  }
}
