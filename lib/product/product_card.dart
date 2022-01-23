import 'package:dm_delights/category/category.dart';
import 'package:dm_delights/product/product.dart';
import 'package:dm_delights/product/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.product,
    required this.category,
  }) : super(key: key);

  final Product product;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            product.imageUrl == null && category.imageUrl == null
                ? const SizedBox(width: 128, height: 128)
                : Image.network(
                    product.imageUrl == null
                        ? category.imageUrl!
                        : product.imageUrl!,
                    width: 128,
                    height: 128,
                  ),
            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            if (product.variants.isNotEmpty)
              Text(
                Translations.of(context)!.price_starts_at(
                  Variant.getLowestPrice(product.variants).price.toInt(),
                ),
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductPage(
              product: product,
              category: category,
            ),
          ),
        );
      },
    );
  }
}
