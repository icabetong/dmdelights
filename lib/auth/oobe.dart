import 'package:dm_delights/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class OutOfBoxExperienceFragment extends StatefulWidget {
  const OutOfBoxExperienceFragment({Key? key}) : super(key: key);

  @override
  _OutOfBoxExperienceFragmentState createState() =>
      _OutOfBoxExperienceFragmentState();
}

class _OutOfBoxExperienceFragmentState
    extends State<OutOfBoxExperienceFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: ThemeComponents.defaultPadding,
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: Translations.of(context)!.field_lastname,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: Translations.of(context)!.field_firstname,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: Translations.of(context)!.field_address,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
