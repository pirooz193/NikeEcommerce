import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/data/repo/authRepository.dart';
import 'package:nike_ecommerce_flutter/ui/cart/cart.dart';
import 'package:nike_ecommerce_flutter/ui/home/home.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/badge.dart';

const int homeIndex = 0;
const int catIndex = 1;
const int profileIndex = 2;

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedScreenIndex = homeIndex;
  final List<int> _history = [];

  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _cartKey = GlobalKey();
  final GlobalKey<NavigatorState> _profileKey = GlobalKey();

  late final map = {
    homeIndex: _homeKey,
    catIndex: _cartKey,
    profileIndex: _profileKey,
  };

  Future<bool> _onWillPop() async {
    final NavigatorState currentSelectedTabNavigatorState =
        map[selectedScreenIndex]!.currentState!;
    if (currentSelectedTabNavigatorState.canPop()) {
      currentSelectedTabNavigatorState.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedScreenIndex = _history.last;
        _history.removeLast();
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: IndexedStack(
            index: selectedScreenIndex,
            children: [
              _navigator(_homeKey, const HomeScreen(), homeIndex),
              _navigator(_cartKey, const CartScreen(), catIndex),
              _navigator(
                  _profileKey,
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('profile'),
                        ElevatedButton(
                            onPressed: () {
                              authRepository.signOut();
                            },
                            child: const Text('خروج'))
                      ],
                    ),
                  ),
                  profileIndex),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home), label: 'خانه'),
              BottomNavigationBarItem(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: const [
                      Icon(CupertinoIcons.cart),
                      Positioned(
                        right: -10,
                        child: BadgeWidget(value: 2),
                      )
                    ],
                  ),
                  label: 'سبد خرید'),
              const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.profile_circled), label: 'پروفایل'),
            ],
            currentIndex: selectedScreenIndex,
            onTap: (selectredIndex) {
              setState(() {
                _history.remove(selectedScreenIndex);
                _history.add(selectedScreenIndex);
                selectedScreenIndex = selectredIndex;
              });
            },
          ),
        ));
  }

  Widget _navigator(GlobalKey key, Widget screen, int index) {
    return key.currentContext == null && selectedScreenIndex != index
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => Offstage(
                  offstage: selectedScreenIndex != index, child: screen),
            ),
          );
  }
}
