import 'package:dm_delights/cart/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class CartList extends StatelessWidget {
  const CartList({Key? key, required this.cartItems}) : super(key: key);

  final List<CartItem> cartItems;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (_, index) {
        return CartListItem(
          cartItem: cartItems[index],
        );
      },
      separatorBuilder: (context, _) => const Divider(),
      itemCount: cartItems.length,
    );
  }
}

class CartListItem extends StatelessWidget {
  const CartListItem({Key? key, required this.cartItem}) : super(key: key);
  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: cartItem.imageUrl != null
          ? Hero(tag: 'product', child: Image.network(cartItem.imageUrl!))
          : const SizedBox(width: 24, height: 24),
      title: Text(cartItem.name,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle:
          Text(Translations.of(context)!.order_quantity(cartItem.quantity)),
    );
  }
}
