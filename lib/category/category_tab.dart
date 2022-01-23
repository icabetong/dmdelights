import 'package:dm_delights/category/category.dart';
import 'package:dm_delights/product/product.dart';
import 'package:dm_delights/product/product_card.dart';
import 'package:flutter/material.dart';

class CategoryTab extends StatefulWidget {
  const CategoryTab({Key? key, required this.category, required this.products})
      : super(key: key);

  final Category category;
  final List<Product> products;

  @override
  _CategoryTabState createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        final product = widget.products[index];
        return ProductCard(
          product: product,
          category: widget.category,
        );
      },
    );
  }
}
