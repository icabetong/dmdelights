import 'package:dm_delights/orders/order.dart';
import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
  const OrderList({Key? key, required this.orders}) : super(key: key);
  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return OrderListTile(
          order: orders[index],
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: orders.length,
    );
  }
}

class OrderListTile extends StatelessWidget {
  const OrderListTile({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(order.id));
  }
}
