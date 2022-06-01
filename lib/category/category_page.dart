import 'package:dm_delights/category/category.dart';
import 'package:dm_delights/category/category_tab.dart';
import 'package:dm_delights/product/product.dart';
import 'package:dm_delights/product/product_notifier.dart';
import 'package:dm_delights/shared/custom/indicator.dart';
import 'package:dm_delights/shared/custom/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key, required this.category}) : super(key: key);

  final Category category;

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    final subcategories =
        widget.category.subcategories ?? [widget.category.name];

    return DefaultTabController(
      length: subcategories.length,
      child: Consumer<ProductNotifier>(builder: (context, notifier, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.category.name),
            bottom: TabBar(
              indicator: DotIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              isScrollable: true,
              tabs:
                  subcategories.map((s) => Tab(text: s.toUpperCase())).toList(),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.pushNamed(context, 'cart');
                },
              )
            ],
          ),
          body: FutureBuilder<List<Product>>(
            future: notifier.products,
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data ?? [];
                return data.isNotEmpty
                    ? TabBarView(
                        children: subcategories
                            .map((s) => CategoryTab(
                                  key: UniqueKey(),
                                  category: widget.category,
                                  products: data.where((d) {
                                    return d.isCorrectType(s);
                                  }).toList(),
                                  onRefresh: notifier.onRefresh,
                                ))
                            .toList(),
                      )
                    : Center(
                        child: Status(
                          icon: Icons.shopping_bag_outlined,
                          title: Translations.of(context)!.empty_products,
                        ),
                      );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    Translations.of(context)!.feedback_error_generic,
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
