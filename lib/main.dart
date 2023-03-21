import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/data/product.dart';
import 'package:nike_ecommerce_flutter/data/repo/bannerRepository.dart';
import 'package:nike_ecommerce_flutter/data/repo/productRepository.dart';
import 'package:nike_ecommerce_flutter/theme.dart';
import 'package:nike_ecommerce_flutter/ui/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    productRepository.getAll(ProductSort.latest).then((value) {
      debugPrint(value.toString());
    }).catchError((e) {
      debugPrint(e.toString());
    });
    bannerRepository.getAll().then((value) {
      debugPrint(value.toString());
    }).catchError((e) {
      debugPrint(e.toString());
    });

    const defaultTextStyle = TextStyle(fontFamily: 'IranYekan');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'noke ecommerce',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: defaultTextStyle,
          headline6: defaultTextStyle.copyWith(fontWeight: FontWeight.bold),
          caption: defaultTextStyle.apply(
              color: LightThemeColors.secondaryTextColor),
        ),
        colorScheme: const ColorScheme.light(
            primary: LightThemeColors.primaryColor,
            secondary: LightThemeColors.secondaryColor,
            onSecondary: Colors.white),
      ),
      home:
          Directionality(textDirection: TextDirection.rtl, child: HomeScreen()),
    );
  }
}
