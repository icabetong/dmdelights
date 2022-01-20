import 'package:dm_delights/auth/auth.dart';
import 'package:dm_delights/cart/cart.dart';
import 'package:dm_delights/category/category_notifier.dart';
import 'package:dm_delights/home/home.dart';
import 'package:dm_delights/shared/custom/state.dart';
import 'package:dm_delights/core/supabase.dart';
import 'package:dm_delights/localization/locales.dart';
import 'package:dm_delights/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Backend.init();
  runApp(const DMDelights());
}

class DMDelights extends StatelessWidget {
  const DMDelights({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoryNotifier>(
          create: (_) => CategoryNotifier(),
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
        onGenerateTitle: (context) => Translations.of(context)!.app_name,
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (_) => const StartupPage(),
          '/auth': (_) => const AuthPage(),
          '/home': (_) => const HomePage(),
          '/cart': (_) => const CartPage(),
        },
      ),
    );
  }
}

class StartupPage extends StatefulWidget {
  const StartupPage({Key? key}) : super(key: key);

  @override
  _StartupPageState createState() => _StartupPageState();
}

class _StartupPageState extends AuthState<StartupPage> {
  @override
  void initState() {
    recoverSupabaseSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
