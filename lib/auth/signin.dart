import 'package:dm_delights/core/infrastructure.dart';
import 'package:dm_delights/shared/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class SignInFragment extends StatefulWidget {
  const SignInFragment({Key? key}) : super(key: key);

  @override
  _SignInFragmentState createState() => _SignInFragmentState();
}

class _SignInFragmentState extends State<SignInFragment> {
  bool _isLoading = false;
  bool _showPassword = true;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    final credential = await Infrastructure.auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.additionalUserInfo != null) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      _emailController.clear();
      _passwordController.clear();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: ThemeComponents.largePadding,
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: Translations.of(context)!.field_email,
                ),
                controller: _emailController,
              ),
              SizedBox(height: ThemeComponents.largeSpacing),
              TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: Translations.of(context)!.field_password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      !_showPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
                controller: _passwordController,
                obscureText: _showPassword,
              ),
              SizedBox(height: ThemeComponents.defaultSpacing),
              TextButton(
                child: Text(Translations.of(context)!.button_forgot_password),
                onPressed: () {},
              ),
              SizedBox(
                height: ThemeComponents.largeSpacing,
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  child: Text(
                    _isLoading
                        ? Translations.of(context)!.feedback_authenticating
                        : Translations.of(context)!.button_signin,
                  ),
                  onPressed: _isLoading ? null : _signIn,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
