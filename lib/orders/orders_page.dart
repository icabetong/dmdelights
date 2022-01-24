import 'package:dm_delights/orders/order.dart';
import 'package:dm_delights/orders/order_list.dart';
import 'package:dm_delights/orders/order_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Translations.of(context)!.route_orders)),
      body: Consumer<OrderNotifier>(
        builder: (context, notifier, _) {
          return FutureBuilder<List<Order>>(
            future: notifier.orders,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return RefreshIndicator(
                    child: OrderList(
                      orders: snapshot.data!,
                    ),
                    onRefresh: () async {});
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
