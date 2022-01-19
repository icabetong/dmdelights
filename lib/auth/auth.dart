import 'package:dm_delights/auth/signin.dart';
import 'package:dm_delights/auth/signup.dart';
import 'package:dm_delights/shared/custom/indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 256,
          title: const Image(
            image: AssetImage('assets/logo.png'),
            width: 256,
            height: 256,
          ),
          centerTitle: true,
          bottom: TabBar(
            indicator: const DotIndicator(color: Colors.pink),
            tabs: [
              Tab(child: Text(Translations.of(context)!.button_signin)),
              Tab(child: Text(Translations.of(context)!.button_signup))
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SignInFragment(),
            SignUpFragment(),
          ],
        ),
      ),
    );
  }
}
