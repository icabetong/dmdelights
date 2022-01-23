import 'package:dm_delights/category/category.dart';
import 'package:dm_delights/product/product.dart';
import 'package:dm_delights/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    Key? key,
    required this.product,
    required this.category,
  }) : super(key: key);
  final Product product;
  final Category category;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Variant? _variant;
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.product.imageUrl == null && widget.category.imageUrl == null
              ? SizedBox()
              : Image.network(
                  widget.product.imageUrl == null
                      ? widget.category.imageUrl!
                      : widget.product.imageUrl!,
                  width: double.infinity,
                  height: 256,
                ),
          Padding(
            padding: ThemeComponents.defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  Translations.of(context)!.select_variant,
                  style: const TextStyle(color: Colors.grey),
                ),
                Wrap(
                  children: widget.product.variants
                      .map((v) => ChoiceChip(
                            label: Text(v.name),
                            selected: _variant == v,
                            onSelected: (checked) {
                              setState(() => _variant = v);
                            },
                          ))
                      .toList(),
                ),
                if (_variant != null)
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(Translations.of(context)!.field_price),
                          const Spacer(),
                          Text(_variant!.price.toString())
                        ],
                      ),
                      Row(
                        children: [
                          Text(Translations.of(context)!.field_quantity),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: _variant!.stock < quantity ? () {} : null,
                        icon: const Icon(Icons.shopping_cart_outlined),
                        label:
                            Text(Translations.of(context)!.button_add_to_cart),
                      )
                    ],
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
