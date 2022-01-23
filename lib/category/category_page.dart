import 'package:dm_delights/category/category.dart';
import 'package:dm_delights/category/category_tab.dart';
import 'package:dm_delights/product/product.dart';
import 'package:dm_delights/product/product_notifier.dart';
import 'package:dm_delights/shared/custom/indicator.dart';
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
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.category.name),
          bottom: TabBar(
            indicator: DotIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            isScrollable: true,
            tabs: subcategories.map((s) => Tab(text: s)).toList(),
          ),
        ),
        body: Consumer<ProductNotifier>(builder: (context, notifier, _) {
          return FutureBuilder<List<Product>>(
            future: notifier.products,
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data ?? [];
                return TabBarView(
                  children: subcategories
                      .map((s) => CategoryTab(
                            key: UniqueKey(),
                            category: widget.category,
                            products: data.where((d) {
                              return d.isCorrectType(s);
                            }).toList(),
                          ))
                      .toList(),
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
          );
        }),
      ),
    );
  }
}
