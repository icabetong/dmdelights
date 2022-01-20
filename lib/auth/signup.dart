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
  bool _hasAccepted = false;
  bool _showPassword = true;
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
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
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
                    icon: Icon(_showPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
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
              SizedBox(height: ThemeComponents.largeSpacing),
              TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: Translations.of(context)!.field_retype_password,
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
                controller: _repasswordController,
                obscureText: _showPassword,
              ),
              SizedBox(height: ThemeComponents.smallSpacing),
              CheckboxListTile(
                dense: true,
                title: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: Translations.of(context)!.field_accept_terms,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      TextSpan(
                          text: Translations.of(context)!.terms_and_conditions,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                          ))
                    ],
                  ),
                ),
                value: _hasAccepted,
                onChanged: (checked) {
                  setState(() => _hasAccepted = checked ?? false);
                },
              ),
              SizedBox(height: ThemeComponents.mediumSpacing),
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
