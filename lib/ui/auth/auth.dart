import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce_flutter/data/repo/authRepository.dart';
import 'package:nike_ecommerce_flutter/ui/auth/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController usernameController =
      TextEditingController(text: "test@gmail.com");
  final TextEditingController passwordController =
      TextEditingController(text: "123456");
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final onBackground = Colors.white;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Theme(
        data: themeData.copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all(const Size.fromHeight(56)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                    backgroundColor: MaterialStateProperty.all(onBackground),
                    foregroundColor: MaterialStateProperty.all(
                        themeData.colorScheme.secondary))),
            snackBarTheme: SnackBarThemeData(
                backgroundColor: themeData.colorScheme.primary,
                contentTextStyle: TextStyle(fontFamily: 'IranYekan')),
            colorScheme: themeData.colorScheme.copyWith(
              onSurface: onBackground,
            ),
            inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(
                  color: onBackground,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    )))),
        child: Scaffold(
          backgroundColor: themeData.colorScheme.secondary,
          body: BlocProvider<AuthBloc>(
            create: (context) {
              final authBloc = AuthBloc(authRepository);
              authBloc.stream.forEach((state) {
                if (state is AuthSuccess) {
                  Navigator.pop(context);
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.exception.message)));
                }
              });
              authBloc.add(AuthStarted());
              return authBloc;
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 48, right: 48),
              child: Center(
                child: Container(
                  width: 400,
                  height: 500,
                  decoration: BoxDecoration(
                    color: themeData.colorScheme.secondary,
                  ),
                  child: BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (previous, current) {
                      return current is AuthLoading ||
                          current is AuthInitial ||
                          current is AuthError;
                    },
                    builder: (context, state) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/img/nike_logo.png',
                              color: Colors.white,
                              width: 120,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Text(
                              state.isLoginMode ? 'خوش آمدید' : 'ثبت نام',
                              style:
                                  TextStyle(color: onBackground, fontSize: 22),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              state.isLoginMode
                                  ? 'لطفا وارد حساب کاربری خود شوید'
                                  : 'ایمیل و رمز عبور خود را تعیین کنید',
                              style:
                                  TextStyle(color: onBackground, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextField(
                              controller: usernameController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(label: Text('ایمیل')),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            _PasswordTextField(
                              onBackground: onBackground,
                              controller: passwordController,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  BlocProvider.of<AuthBloc>(context).add(
                                      AuthButtonIsClicked(
                                          usernameController.text,
                                          passwordController.text));
                                },
                                child: state is AuthLoading
                                    ? CircularProgressIndicator()
                                    : Text(state.isLoginMode
                                        ? 'ورود'
                                        : 'ثبت نام')),
                            const SizedBox(
                              height: 24,
                            ),
                            GestureDetector(
                              onTap: () {
                                BlocProvider.of<AuthBloc>(context)
                                    .add(AuthModeChangeIsClicked());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    state.isLoginMode
                                        ? 'حساب کاربری ندارید ؟'
                                        : 'حساب کاربری دارید؟',
                                    style: TextStyle(
                                        color: onBackground.withOpacity(0.7)),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    state.isLoginMode ? 'ثبت نام' : 'ورود',
                                    style: TextStyle(
                                      color: themeData.colorScheme.primary,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  const _PasswordTextField({
    Key? key,
    required this.onBackground,
    required this.controller,
  }) : super(key: key);

  final Color onBackground;

  @override
  State<_PasswordTextField> createState() =>
      _PasswordTextFieldState(controller);
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool obSecuredText = true;

  final TextEditingController controller;

  _PasswordTextFieldState(this.controller);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obSecuredText,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obSecuredText = !obSecuredText;
              });
            },
            icon: Icon(
              obSecuredText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: widget.onBackground.withOpacity(0.6),
            ),
          ),
          label: const Text('رمز عبور')),
    );
  }
}
