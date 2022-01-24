import 'package:dm_delights/core/repository.dart';
import 'package:dm_delights/orders/order.dart';
import 'package:flutter/widgets.dart';

class OrderNotifier extends ChangeNotifier {
  final _repository = OrderRepository();
  final _cart = CartRepository();
  late Future<List<Order>> _orders;
  Future<List<Order>> get orders => _orders;

  OrderNotifier() {
    _orders = _repository.fetch();
  }

  Future<void> insert(Order order) async {
    _repository.insert(order);
    _orders = _repository.fetch();
    await _cart.reset();
    notifyListeners();
  }
}
