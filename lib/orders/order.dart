import 'package:dm_delights/cart/cart_item.dart';

class Order {
  String id;
  List<CartItem> cartItems;
  String ownerId;

  Order({required this.id, required this.cartItems, required this.ownerId});

  static Order fromMap(Map<String, dynamic> doc) {
    Iterable? _cartItems = doc['cartItems'];
    List<Map<String, dynamic>> cartItems =
        _cartItems?.map((o) => Map<String, dynamic>.from(o)).toList() ?? [];

    return Order(
      id: doc['id'],
      cartItems: cartItems.map((o) => CartItem.fromMap(o)).toList(),
      ownerId: doc['ownerId'],
    );
  }

  static Map<String, dynamic> toMap(Order order) {
    return <String, dynamic>{
      'id': order.id,
      'cartItems': order.cartItems.map((e) => CartItem.toMap(e)).toList(),
      'ownerId': order.ownerId
    };
  }
}
