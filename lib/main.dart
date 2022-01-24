import 'dart:async';

import 'package:animations/animations.dart';
import 'package:dm_delights/auth/auth.dart';
import 'package:dm_delights/cart/cart_notifier.dart';
import 'package:dm_delights/cart/cart_page.dart';
import 'package:dm_delights/category/category_notifier.dart';
import 'package:dm_delights/core/infrastructure.dart';
import 'package:dm_delights/home/home.dart';
import 'package:dm_delights/localization/locales.dart';
import 'package:dm_delights/orders/order_notifier.dart';
import 'package:dm_delights/product/product_notifier.dart';
import 'package:dm_delights/profile/profile_notifier.dart';
import 'package:dm_delights/shared/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Infrastructure.init();
  runApp(const DMDelights());
}

class DMDelights extends StatefulWidget {
  const DMDelights({Key? key}) : super(key: key);

  @override
  State<DMDelights> createState() => _DMDelightsState();
}

class _DMDelightsState extends State<DMDelights> {
  late StreamSubscription<User?> _subscription;

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _subscription = Infrastructure.auth.userChanges().listen((event) {
      _navigatorKey.currentState!.pushReplacementNamed(
        event != null ? 'home' : 'auth',
      );
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoryNotifier>(
          create: (_) => CategoryNotifier(),
        ),
        ChangeNotifierProvider<ProductNotifier>(
          create: (_) => ProductNotifier(),
        ),
        ChangeNotifierProvider<CartNotifier>(
          create: (_) => CartNotifier(),
        ),
        ChangeNotifierProvider<ProfileNotifier>(
          create: (_) => ProfileNotifier(),
        ),
        ChangeNotifierProvider<OrderNotifier>(
          create: (_) => OrderNotifier(),
        )
      ],
      child: MaterialApp(
        title: 'DM Delights',
        theme: light,
        supportedLocales: Locales.all,
        localizationsDelegates: const [
          Translations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        navigatorKey: _navigatorKey,
        initialRoute: Infrastructure.auth.currentUser == null ? 'auth' : 'home',
        onGenerateTitle: (context) => Translations.of(context)!.app_name,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case 'auth':
              return MaterialPageRoute(
                  settings: settings, builder: (_) => const AuthPage());
            case 'home':
              return MaterialPageRoute(
                  settings: settings, builder: (_) => const HomePage());
            case 'cart':
              return PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const CartPage();
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SharedAxisTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                    transitionType: SharedAxisTransitionType.horizontal,
                  );
                },
              );
            default:
              return MaterialPageRoute(
                  settings: settings, builder: (_) => const StartPage());
          }
        },
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
