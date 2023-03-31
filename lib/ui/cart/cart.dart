import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/data/authInfo.dart';
import 'package:nike_ecommerce_flutter/data/repo/authRepository.dart';
import 'package:nike_ecommerce_flutter/ui/auth/auth.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('سبد خرید'),
      ),
      body: ValueListenableBuilder<AuthInfo?>(
        valueListenable: AuthRepository.authChangeNotifier,
        builder: (context, authState, child) {
          bool isAuthenticated =
              authState != null && authState!.accessToken.isNotEmpty;
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isAuthenticated
                      ? 'خوش آمدید'
                      : 'لطفا وارد حساب کاربری خود شوید'),
                  isAuthenticated
                      ? ElevatedButton(
                          onPressed: () {
                            authRepository.signOut();
                          },
                          child: Text('خروج از حساب کاربری'))
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                              builder: (context) => const AuthScreen(),
                            ));
                          },
                          child: Text('ورود')),
                  ElevatedButton(
                      onPressed: () async {
                        authRepository.refreshToken();
                      },
                      child: Text('Refresh Token'))
                ]),
          );
        },
      ),
    );
  }
}
