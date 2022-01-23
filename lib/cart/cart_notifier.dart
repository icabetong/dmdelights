import 'package:dm_delights/cart/cart_item.dart';
import 'package:dm_delights/core/repository.dart';
import 'package:flutter/cupertino.dart';

class CartNotifier extends ChangeNotifier {
  final _repository = CartRepository();
  late Future<List<CartItem>> _cartItems;
  Future<List<CartItem>> get cartItems => _cartItems;

  CartNotifier() {
    _cartItems = _repository.fetch();
  }

  Future reset() async {
    _cartItems = _repository.fetch();
    notifyListeners();
  }

  Future insert(CartItem item) async {
    _repository.insert(item);
    _cartItems = _repository.fetch();
    notifyListeners();
  }

  Future update(CartItem item) async {
    _repository.update(item);
    _cartItems = _repository.fetch();
    notifyListeners();
  }

  Future remove(CartItem item) async {
    _repository.remove(item);
    _cartItems = _repository.fetch();
    notifyListeners();
  }

  static double getTotal(List<CartItem> cartItems) {
    double price = 0;
    for (var e in cartItems) {
      price += e.variant.price;
    }
    return price;
  }
}
