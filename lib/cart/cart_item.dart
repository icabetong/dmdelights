import 'package:dm_delights/product/product.dart';

class CartItem {
  String id;
  String name;
  Variant variant;
  int quantity;
  String? imageUrl;

  CartItem({
    required this.id,
    required this.name,
    required this.variant,
    required this.quantity,
    this.imageUrl,
  });

  static Map<String, dynamic> toMap(CartItem item) {
    return <String, dynamic>{
      'id': item.id,
      'name': item.name,
      'variant': Variant.toMap(item.variant),
      'quantity': item.quantity,
      'imageUrl': item.imageUrl,
    };
  }

  static CartItem fromMap(Map<String, dynamic> doc) {
    return CartItem(
      id: doc['id'],
      name: doc['name'],
      variant: Variant.fromMap(doc['variant']),
      quantity: doc['quantity'],
      imageUrl: doc['imageUrl'],
    );
  }
}
