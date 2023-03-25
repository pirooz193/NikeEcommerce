import 'package:flutter/foundation.dart';
import 'package:nike_ecommerce_flutter/common/http_client.dart';
import 'package:nike_ecommerce_flutter/data/authInfo.dart';
import 'package:nike_ecommerce_flutter/data/source/auth_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepository = AuthRepository(AuthRemoteDataSource(httpClient));

abstract class IAuthRepository {
  Future<void> login(String username, String password);
  Future<void> refreshToken();
}

class AuthRepository implements IAuthRepository {
  static final ValueNotifier<AuthInfo?> authChangeNotifier =
      ValueNotifier(null);
  final IAuthDataSource dataSource;

  AuthRepository(
    this.dataSource,
  );

  @override
  Future<void> login(String username, String password) async {
    final AuthInfo authInfo = await dataSource.login(username, password);
    _persistAuthTokens(authInfo);
    debugPrint("access token : " + authInfo.accessToeken);
  }

  @override
  Future<void> refreshToken() async {
    final AuthInfo authInfo = await dataSource.refreshToken(
        "def50200a50b4409b7e19aba5316f1851ed87d6a17e17de6ad12ec7a22574db01c40bc14a2bee3603c7b7ea1d22d910c85a290fd1183748458d9d0ac0fea53c63f3d1491f2569bf59b7139f7bb4eeca4ab90df3c5dc684258142790b80b48d90ed343f116f0dddf08a5459f412416b7996afcec875c726f85f4e04c27bd3e90cee53873f8165efa3e935c0a92c7581b88a14ee779d01f94d9ea4f00c4760c6dd8a7ad911952abe6a40a4cfa064f404aab8d901474422993bef790210030a1d57ce3c447e5e92ea5c04d44eb5bbafdddbda46a2b5e608831dffa57a07e8b800883848ffa3fe6e781c75a08c90d7442e91bc47ad0dbdc2e1ee409c10a39b23212ed353e1e939fb3569a858fbb6de6413e9f92ad051443ddc00ee7aca787b688d09457f084a742aaa111c66548a2f523cf1f79a6d7428730d19c872e172c116d828b3881be7b34ec9873c934601c803c288ccc325d6f6c8e9788bbe2d66a1628f8c");
    _persistAuthTokens(authInfo);
  }

  Future<void> _persistAuthTokens(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString("access_token", authInfo.accessToeken);
    sharedPreferences.setString("refresh_token", authInfo.refreshToeken);
  }

  Future<void> loadAuthInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String accessToken =
        await sharedPreferences.getString("access_token") ?? '';
    final String refreshToken =
        await sharedPreferences.getString("refresh_token") ?? '';

    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      authChangeNotifier.value = AuthInfo(
          sharedPreferences.getString(accessToken)!,
          sharedPreferences.getString(refreshToken)!);
    }
  }
}
