import 'package:dm_delights/profile/profile_notifier.dart';
import 'package:dm_delights/profile/tabs/address.dart';
import 'package:dm_delights/profile/tabs/info.dart';
import 'package:dm_delights/profile/tabs/security.dart';
import 'package:dm_delights/shared/custom/indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(Translations.of(context)!.route_profile),
          bottom: TabBar(
            tabs: [
              Tab(child: Text(Translations.of(context)!.tab_info)),
              Tab(child: Text(Translations.of(context)!.tab_address)),
              Tab(child: Text(Translations.of(context)!.tab_security)),
            ],
            indicator: DotIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        body: Consumer<ProfileNotifier>(builder: (context, notifier, _) {
          if (notifier.profile != null) {
            return TabBarView(children: [
              InfoTab(profile: notifier.profile!),
              AddressTab(address: notifier.profile!.address),
              const SecurityTab(),
            ]);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
