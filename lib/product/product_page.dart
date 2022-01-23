import 'package:dm_delights/cart/cart_item.dart';
import 'package:dm_delights/cart/cart_notifier.dart';
import 'package:dm_delights/category/category.dart';
import 'package:dm_delights/product/product.dart';
import 'package:dm_delights/shared/custom/numeric.dart';
import 'package:dm_delights/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

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
  int _quantity = 1;

  void _onAddToCart() {
    CartItem cartItem = CartItem(
      id: widget.product.id,
      name: widget.product.name,
      variant: _variant!,
      quantity: _quantity,
    );

    Provider.of<CartNotifier>(context, listen: false).insert(cartItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.pushNamed(context, 'cart');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.product.imageUrl == null && widget.category.imageUrl == null
                ? const SizedBox()
                : Hero(
                    tag: widget.product.id,
                    child: Image.network(
                      widget.product.imageUrl == null
                          ? widget.category.imageUrl!
                          : widget.product.imageUrl!,
                      width: double.infinity,
                      height: 256,
                    ),
                  ),
            Padding(
              padding: ThemeComponents.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      const Spacer(),
                      Text(
                        _variant == null
                            ? Translations.of(context)!.price_starts_at(
                                Variant.format(Variant.getLowestPrice(
                                        widget.product.variants)
                                    .price))
                            : Variant.format(_variant!.price),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
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
                  const SizedBox(height: 16),
                  if (_variant != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Translations.of(context)!.field_quantity),
                        NumericStepper(
                          value: _quantity,
                          min: 0,
                          max: _variant!.stock.toInt(),
                          onChanged: (value) {
                            setState(() => _quantity = value);
                          },
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: _quantity <= _variant!.stock
                                ? _onAddToCart
                                : null,
                            icon: const Icon(Icons.shopping_cart_outlined),
                            label: Text(
                                Translations.of(context)!.button_add_to_cart),
                          ),
                        )
                      ],
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
