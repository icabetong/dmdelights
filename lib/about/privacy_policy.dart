import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context)!.route_privacy_policy),
      ),
    );
  }
}
