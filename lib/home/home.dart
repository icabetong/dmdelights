import 'package:dm_delights/about/privacy_policy.dart';
import 'package:dm_delights/about/store.dart';
import 'package:dm_delights/cart/cart_page.dart';
import 'package:dm_delights/category/category_grid.dart';
import 'package:dm_delights/category/category_notifier.dart';
import 'package:dm_delights/category/category.dart';
import 'package:dm_delights/core/infrastructure.dart';
import 'package:dm_delights/orders/orders_page.dart';
import 'package:dm_delights/profile/profile_page.dart';
import 'package:dm_delights/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool?> _onConfirmEndSession() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Translations.of(context)!.dialog_signout_title),
          content: Text(Translations.of(context)!.dialog_signout_message),
          actions: <Widget>[
            TextButton(
              child: Text(Translations.of(context)!.button_continue),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: Text(Translations.of(context)!.button_cancel),
              onPressed: () {
                Navigator.pop(context, false);
              },
            )
          ],
        );
      },
    );
  }

  Widget _onNavigate(Route route) {
    switch (route) {
      case Route.profile:
        return const ProfilePage();
      case Route.orders:
        return const OrdersPage();
      case Route.store:
        return const StoreProfilePage();
      case Route.policies:
        return const PrivacyPolicyPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context)!.app_name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.pushNamed(context, 'cart');
            },
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(height: ThemeComponents.largeSpacing),
            ListView.builder(
              shrinkWrap: true,
              itemCount: Route.values.length,
              itemBuilder: (BuildContext context, int index) {
                final route = Route.values[index];

                return ListTile(
                  title: Text(
                    route.getLocalization(context),
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  leading: Icon(
                    route.icon,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => _onNavigate(route),
                      ),
                    );
                  },
                );
              },
            ),
            const Spacer(flex: 1),
            TextButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Text(
                      Translations.of(context)!.button_signout,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_outlined,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ],
                ),
              ),
              onPressed: () async {
                final response = await _onConfirmEndSession();
                if (response == true) {
                  await Infrastructure.auth.signOut();
                  if (Infrastructure.auth.currentUser == null) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      'auth',
                      (route) => false,
                    );
                  }
                }
              },
            )
          ],
        ),
      ),
      body: Consumer<CategoryNotifier>(builder: (context, notifier, _) {
        return RefreshIndicator(
          onRefresh: () async {
            await notifier.refresh();
          },
          child: FutureBuilder<List<Category>>(
            future: notifier.categories,
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return CategoryGrid(categories: snapshot.data!);
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    Translations.of(context)!.feedback_error_generic,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        );
      }),
    );
  }
}

enum Route { profile, orders, store, policies }

extension RouteExtension on Route {
  String getLocalization(BuildContext context) {
    switch (this) {
      case Route.profile:
        return Translations.of(context)!.route_profile;
      case Route.orders:
        return Translations.of(context)!.route_orders;
      case Route.store:
        return Translations.of(context)!.route_store_profile;
      case Route.policies:
        return Translations.of(context)!.route_privacy_policy;
    }
  }

  IconData get icon {
    switch (this) {
      case Route.profile:
        return Icons.account_circle_outlined;
      case Route.orders:
        return Icons.shopping_bag_outlined;
      case Route.store:
        return Icons.sell_outlined;
      case Route.policies:
        return Icons.article_outlined;
    }
  }
}
