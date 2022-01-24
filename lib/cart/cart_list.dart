import 'package:dm_delights/cart/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class CartList extends StatelessWidget {
  const CartList({
    Key? key,
    required this.cartItems,
    required this.onSelect,
    required this.onAction,
  }) : super(key: key);

  final List<CartItem> cartItems;
  final Function(CartItem) onSelect;
  final Function(CartItem, CartAction) onAction;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (_, index) {
        return CartListItem(
          cartItem: cartItems[index],
          onSelect: onSelect,
          onAction: onAction,
        );
      },
      separatorBuilder: (context, _) => const Divider(),
      itemCount: cartItems.length,
    );
  }
}

class CartListItem extends StatelessWidget {
  const CartListItem({
    Key? key,
    required this.cartItem,
    required this.onSelect,
    required this.onAction,
  }) : super(key: key);
  final CartItem cartItem;
  final Function(CartItem) onSelect;
  final Function(CartItem, CartAction) onAction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: cartItem.imageUrl != null
          ? Hero(tag: cartItem.id, child: Image.network(cartItem.imageUrl!))
          : const SizedBox(width: 24, height: 24),
      title: Text(cartItem.name,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle:
          Text(Translations.of(context)!.order_quantity(cartItem.quantity)),
      trailing: PopupMenuButton<CartAction>(
        onSelected: (CartAction action) {
          onAction(cartItem, action);
        },
        itemBuilder: (context) => CartAction.values.map((action) {
          return PopupMenuItem<CartAction>(
            value: action,
            child: Text(action.getLocalization(context)),
          );
        }).toList(),
      ),
      onTap: () {
        onSelect(cartItem);
      },
    );
  }
}

enum CartAction { edit, remove }

extension CartActionExtension on CartAction {
  String getLocalization(BuildContext context) {
    switch (this) {
      case CartAction.edit:
        return Translations.of(context)!.button_edit;
      case CartAction.remove:
        return Translations.of(context)!.button_remove;
    }
  }
}
