import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class StoreProfilePage extends StatelessWidget {
  const StoreProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context)!.route_store_profile),
      ),
    );
  }
}
