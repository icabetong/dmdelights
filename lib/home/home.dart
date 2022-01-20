import 'package:dm_delights/category/category_notifier.dart';
import 'package:dm_delights/category/category.dart';
import 'package:dm_delights/core/supabase.dart';
import 'package:dm_delights/shared/custom/state.dart';
import 'package:dm_delights/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends AuthRequiredState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context)!.app_name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
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
              onPressed: () {
                Backend.instance.auth.signOut();
              },
            )
          ],
        ),
      ),
      body: Consumer<CategoryNotifier>(builder: (context, notifier, _) {
        return Padding(
          padding: ThemeComponents.defaultPadding,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder<List<Category>>(
                  future: notifier.categories,
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      debugPrint(snapshot.data!.length.toString());
                      return Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            final type = snapshot.data![index];

                            return Card(
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.network(
                                      type.avatar ?? '',
                                      height: 128,
                                      fit: BoxFit.scaleDown,
                                    ),
                                    SizedBox(
                                      height: ThemeComponents.defaultSpacing,
                                    ),
                                    Text(type.name ?? '')
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
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
                )
              ],
            ),
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
