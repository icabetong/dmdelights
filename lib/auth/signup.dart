import 'package:dm_delights/core/supabase.dart';
import 'package:dm_delights/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class SignUpFragment extends StatefulWidget {
  const SignUpFragment({Key? key}) : super(key: key);

  @override
  _SignUpFragmentState createState() => _SignUpFragmentState();
}

class _SignUpFragmentState extends State<SignUpFragment> {
  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _repasswordController;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await Backend.instance.auth.signUp(email, password);

    final error = response.error;
    if (error != null) {
      debugPrint(error.toString());
    } else {
      _emailController.clear();
      _passwordController.clear();
      _repasswordController.clear();
    }

    setState(() {
      _isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
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
                ),
                controller: _passwordController,
              ),
              SizedBox(height: ThemeComponents.largeSpacing),
              TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: Translations.of(context)!.field_retype_password,
                ),
                controller: _repasswordController,
              ),
              SizedBox(height: ThemeComponents.defaultSpacing),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  child: Text(_isLoading
                      ? Translations.of(context)!.feedback_authenticating
                      : Translations.of(context)!.button_signup),
                  onPressed: _isLoading ? null : _signUp,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
