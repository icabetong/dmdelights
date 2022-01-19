import 'package:dm_delights/auth/auth.dart';
import 'package:dm_delights/auth/state.dart';
import 'package:dm_delights/core/supabase.dart';
import 'package:dm_delights/localization/locales.dart';
import 'package:dm_delights/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: Backend.URL, anonKey: Backend.ANON_KEY);
  runApp(const DMDelights());
}

class DMDelights extends StatelessWidget {
  const DMDelights({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        '/app': (_) => const MainPage()
      },
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

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends AuthRequiredState<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context)!.app_name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
