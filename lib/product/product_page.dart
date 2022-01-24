import 'package:dm_delights/cart/cart_item.dart';
import 'package:dm_delights/cart/cart_notifier.dart';
import 'package:dm_delights/product/product.dart';
import 'package:dm_delights/product/product_notifier.dart';
import 'package:dm_delights/shared/custom/numeric.dart';
import 'package:dm_delights/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    Key? key,
    this.product,
    this.productId,
  }) : super(key: key);
  final Product? product;
  final String? productId;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<Product?> _product;
  Variant? _variant;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      _product = Future.sync(() => widget.product);
    } else if (widget.product == null && widget.productId != null) {
      final provider = Provider.of<ProductNotifier>(context, listen: false);
      _product = provider.fetchSingle(widget.productId!);
    } else {
      throw Exception('Both product and productId arguments cannot be null');
    }
  }

  void _onAddToCart(Product product) async {
    CartItem cartItem = CartItem(
      id: product.id,
      name: product.name,
      variant: _variant!,
      quantity: _quantity,
    );

    await Provider.of<CartNotifier>(context, listen: false).insert(cartItem);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(Translations.of(context)!.feedback_added_to_cart),
    ));
  }

  Widget getPage(Product product) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          product.imageUrl == null
              ? const SizedBox(height: 256)
              : Hero(
                  tag: product.id,
                  child: Image.network(
                    product.imageUrl!,
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
                      product.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    const Spacer(),
                    Text(
                      _variant == null
                          ? Translations.of(context)!.price_starts_at(
                              Variant.format(
                                  Variant.getLowestPrice(product.variants)
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
                  children: product.variants
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
                        max: 10,
                        onChanged: (value) {
                          setState(() => _quantity = value);
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _variant!.available
                              ? () {
                                  _onAddToCart(product);
                                }
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
    );
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
      body: FutureBuilder<Product?>(
        future: _product,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return getPage(snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(Translations.of(context)!.feedback_error_generic),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
