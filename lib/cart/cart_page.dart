import 'package:animations/animations.dart';
import 'package:dm_delights/auth/signup.dart';
import 'package:dm_delights/cart/cart_item.dart';
import 'package:dm_delights/cart/cart_list.dart';
import 'package:dm_delights/cart/cart_notifier.dart';
import 'package:dm_delights/core/infrastructure.dart';
import 'package:dm_delights/orders/order.dart';
import 'package:dm_delights/orders/order_notifier.dart';
import 'package:dm_delights/product/product_page.dart';
import 'package:dm_delights/shared/custom/status.dart';
import 'package:dm_delights/shared/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final NumberFormat currencyFormat =
      NumberFormat.compactCurrency(locale: 'tl');
  bool isDelivery = false;

  Widget getBottom(List<CartItem> cartItems) {
    return Material(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Text(Translations.of(context)!.field_delivery),
                  selected: isDelivery,
                  onSelected: cartItems.isEmpty
                      ? null
                      : (_) {
                          setState(() => isDelivery = true);
                        },
                ),
                ChoiceChip(
                  label: Text(Translations.of(context)!.field_pick_up),
                  selected: !isDelivery,
                  onSelected: cartItems.isEmpty
                      ? null
                      : (_) {
                          setState(() => isDelivery = false);
                        },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text(
                    Translations.of(context)!.field_total,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  Text(
                    currencyFormat.format(CartNotifier.getTotal(cartItems)),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text(
                  Translations.of(context)!.button_proceed_to_checkout,
                ),
                onPressed: cartItems.isEmpty
                    ? null
                    : () {
                        _onCheckout(cartItems);
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCheckout(List<CartItem> cartItems) async {
    final user = Infrastructure.auth.currentUser;
    final userId = user?.uid;

    if (user?.isAnonymous == true) {
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const SignUpPage();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        ),
      );
    }

    if (userId != null) {
      final order = Order(
        id: randomId(),
        cartItems: cartItems,
        ownerId: userId,
      );

      await Provider.of<OrderNotifier>(context, listen: false).insert(order);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(Translations.of(context)!.feedback_order_sent),
      ));
    }
  }

  void _onAction(CartItem item, CartAction action) async {
    switch (action) {
      case CartAction.edit:
        break;
      case CartAction.remove:
        await _onRemove(item);
        break;
    }
  }

  void _onSelect(CartItem cartItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPage(
          productId: cartItem.id,
        ),
      ),
    );
  }

  Future<void> _onEdit() async {}
  Future<void> _onRemove(CartItem item) async {
    final response = await _showRemovePrompt(item);
    if (response == true) {
      Provider.of<CartNotifier>(context, listen: false).remove(item);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Translations.of(context)!.feedback_remove_from_cart,
          ),
        ),
      );
    }
  }

  Future<bool?> _showRemovePrompt(CartItem item) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            Translations.of(context)!.dialog_remove_cart_item(item.name),
          ),
          content: Text(
            Translations.of(context)!.dialog_remove_cart_item_message,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(Translations.of(context)!.button_remove),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: Text(Translations.of(context)!.button_cancel),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context)!.route_carts),
      ),
      body: Consumer<CartNotifier>(
        builder: (context, notifier, _) {
          return FutureBuilder<List<CartItem>>(
            future: notifier.cartItems,
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await notifier.reset();
                  },
                  child: Column(
                    children: [
                      snapshot.data!.isEmpty
                          ? Expanded(
                              flex: 2,
                              child: Status(
                                icon: Icons.add_shopping_cart_outlined,
                                title: Translations.of(context)!.empty_cart,
                              ),
                            )
                          : Expanded(
                              flex: 1,
                              child: CartList(
                                cartItems: snapshot.data!,
                                onSelect: _onSelect,
                                onAction: _onAction,
                              ),
                            ),
                      getBottom(snapshot.data!),
                    ],
                  ),
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
        },
      ),
    );
  }
}
