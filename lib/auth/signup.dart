import 'package:dm_delights/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class SignUpFragment extends StatefulWidget {
  const SignUpFragment({Key? key}) : super(key: key);

  @override
  _SignUpFragmentState createState() => _SignUpFragmentState();
}

class _SignUpFragmentState extends State<SignUpFragment> {
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
              ),
              SizedBox(height: ThemeComponents.largeSpacing),
              TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: Translations.of(context)!.field_password,
                ),
              ),
              SizedBox(height: ThemeComponents.largeSpacing),
              TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: Translations.of(context)!.field_retype_password,
                ),
              ),
              SizedBox(height: ThemeComponents.defaultSpacing),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  child: Text(Translations.of(context)!.button_signup),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
