import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context)!.route_orders),
      ),
      body: Column(),
    );
  }
}
