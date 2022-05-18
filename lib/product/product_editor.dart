import 'dart:async';

import 'package:dm_delights/category/category.dart';
import 'package:dm_delights/core/repository.dart';
import 'package:dm_delights/product/product.dart';
import 'package:dm_delights/shared/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class ProductEditor extends StatefulWidget {
  ProductEditor({Key? key}) : super(key: key);

  @override
  State<ProductEditor> createState() => _ProductEditorState();
}

class _ProductEditorState extends State<ProductEditor> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _type = TextEditingController();
  final TextEditingController _variantName = TextEditingController();
  final TextEditingController _variantPrice = TextEditingController();
  Category? _category = null;
  late Future<List<Category>> _categories;
  List<Variant> _variants = [];

  void onSaveVariant() {
    final variantName = _variantName.text;
    final variantPrice = _variantPrice.text;

    final index = _variants.indexWhere((v) => v.name == variantName);
    final variants = _variants;
    final variant = Variant(variantName, double.parse(variantPrice), true);
    if (index < 0) {
      variants[index] = variant;
    } else {
      variants.add(variant);
    }
    setState(() => _variants = variants);
  }

  @override
  void initState() {
    super.initState();
    _categories = CategoryRepository().fetch();
  }

  Future<void> onSave() async {
    if (_category == null) return;

    final product = Product(
        name: _name.text,
        category: _category!.id,
        type: _type.text,
        variants: _variants,
        id: randomId());
    await ProductRepository().insert(product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: onSave,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(label: Text("Product")),
              controller: _name,
            ),
            TextField(
              decoration: InputDecoration(label: Text("Type")),
              controller: _type,
            ),
            FutureBuilder<List<Category>>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final categories = snapshot.requireData;

                  return DropdownButton<Category>(
                      value: _category,
                      items: categories.map((category) {
                        return DropdownMenuItem<Category>(
                          child: Text(category.name),
                          value: category,
                        );
                      }).toList(),
                      onChanged: (newCategory) {
                        setState(() => _category = newCategory);
                      });
                } else if (snapshot.hasError) {
                  return Container();
                }
                return Container();
              },
              future: _categories,
            ),
            Padding(
              child: Text("Variants"),
              padding: EdgeInsets.only(top: 32),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _variants.length,
              itemBuilder: (BuildContext context, int index) {
                final variant = _variants[index];
                return ListTile(
                  title: Text(variant.name),
                  subtitle: Text(variant.price.toString()),
                );
              },
            ),
            TextField(
              controller: _variantName,
            ),
            TextField(
              controller: _variantPrice,
            ),
            Checkbox(
              onChanged: (bool? value) {},
              value: false,
            ),
            OutlinedButton.icon(
              onPressed: onSaveVariant,
              icon: const Icon(Icons.add),
              label: Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}