import 'package:dm_delights/profile/profile.dart';
import 'package:dm_delights/profile/profile_notifier.dart';
import 'package:dm_delights/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class AddressTab extends StatefulWidget {
  const AddressTab({Key? key, required this.address}) : super(key: key);

  final Address? address;

  @override
  _AddressTabState createState() => _AddressTabState();
}

class _AddressTabState extends State<AddressTab> {
  late TextEditingController _blockController;
  late TextEditingController _streetController;
  late TextEditingController _villageController;
  late TextEditingController _cityController;
  late TextEditingController _zipCodeController;
  late TextEditingController _proviceController;

  bool _updating = false;

  @override
  void initState() {
    super.initState();

    Address? address = widget.address;
    _blockController = TextEditingController(text: address?.number);
    _streetController = TextEditingController(text: address?.street);
    _villageController = TextEditingController(text: address?.village);
    _cityController = TextEditingController(text: address?.city);
    _zipCodeController =
        TextEditingController(text: address?.zipcode.toString());
    _proviceController = TextEditingController(text: address?.province);
  }

  void _onSave() async {
    setState(() => _updating = true);
    final notifier = Provider.of<ProfileNotifier>(context, listen: false);

    final address = Address(
      number: _blockController.text,
      street: _streetController.text,
      village: _villageController.text,
      city: _cityController.text,
      zipcode: int.parse(_zipCodeController.text),
      province: _proviceController.text,
    );

    final _profile = notifier.profile;
    if (_profile != null) {
      Profile profile = _profile;
      profile.address = address;

      notifier.update(Profile.toMap(profile));
      setState(() => _updating = false);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(Translations.of(context)!.feedback_address_updated),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: ThemeComponents.defaultPadding,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: Translations.of(context)!.field_house_block_room_no,
                icon: const Icon(Icons.house_outlined),
              ),
              controller: _blockController,
            ),
            SizedBox(height: ThemeComponents.defaultSpacing),
            TextFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: Translations.of(context)!.field_street,
                icon: const Icon(null),
              ),
              controller: _streetController,
            ),
            SizedBox(height: ThemeComponents.defaultSpacing),
            TextFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: Translations.of(context)!.field_village,
                icon: const Icon(null),
              ),
              controller: _villageController,
            ),
            SizedBox(height: ThemeComponents.defaultSpacing),
            TextFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: Translations.of(context)!.field_city,
                icon: const Icon(Icons.traffic_outlined),
              ),
              controller: _cityController,
            ),
            SizedBox(height: ThemeComponents.defaultSpacing),
            TextFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: Translations.of(context)!.field_zipcode,
                icon: const Icon(null),
              ),
              controller: _zipCodeController,
            ),
            SizedBox(height: ThemeComponents.defaultSpacing),
            TextFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: Translations.of(context)!.field_province,
                icon: const Icon(null),
              ),
              controller: _proviceController,
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
