import 'package:dm_delights/profile/profile.dart';
import 'package:dm_delights/profile/profile_notifier.dart';
import 'package:dm_delights/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class InfoTab extends StatefulWidget {
  InfoTab({Key? key, required this.profile}) : super(key: key);

  Profile profile;

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  late TextEditingController _lastnameController;
  late TextEditingController _firstnameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  bool _updating = false;

  @override
  void initState() {
    super.initState();

    Profile profile = widget.profile;
    _lastnameController = TextEditingController(text: profile.lastname);
    _firstnameController = TextEditingController(text: profile.firstname);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
  }

  @override
  void dispose() {
    _lastnameController.dispose();
    _firstnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSave() async {
    setState(() => _updating = true);
    final profile = Profile(
      lastname: _lastnameController.text,
      firstname: _firstnameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
    );

    await Provider.of<ProfileNotifier>(context, listen: false)
        .update(Profile.toMap(profile));
    setState(() => _updating = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(Translations.of(context)!.feedback_profile_updated),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: ThemeComponents.defaultPadding,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: Translations.of(context)!.field_lastname,
                icon: const Icon(Icons.edit_outlined),
              ),
              controller: _lastnameController,
              keyboardType: TextInputType.name,
              enabled: !_updating,
            ),
            SizedBox(height: ThemeComponents.defaultSpacing),
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: Translations.of(context)!.field_firstname,
                icon: const Icon(null),
              ),
              controller: _firstnameController,
              keyboardType: TextInputType.name,
              enabled: !_updating,
            ),
            SizedBox(height: ThemeComponents.defaultSpacing),
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: Translations.of(context)!.field_email,
                icon: const Icon(Icons.email_outlined),
              ),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              enabled: !_updating,
            ),
            SizedBox(height: ThemeComponents.defaultSpacing),
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: Translations.of(context)!.field_phone,
                icon: const Icon(Icons.phone_outlined),
              ),
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              enabled: !_updating,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save_outlined),
                label: Text(Translations.of(context)!.button_save),
                onPressed: _updating ? null : _onSave,
              ),
            )
          ],
        ),
      ),
    );
  }
}
