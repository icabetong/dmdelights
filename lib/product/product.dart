import 'package:intl/intl.dart';

class Product {
  String id;
  String name;
  String category;
  String? type;
  String? imageUrl;
  List<Variant> variants;

  Product({
    required this.id,
    required this.name,
    required this.category,
    this.type,
    this.imageUrl,
    this.variants = const [],
  });

  bool isCorrectType(String type) {
    return this.type?.toLowerCase() == type.toLowerCase();
  }

  static Product fromMap(Map<String, dynamic> doc) {
    Iterable? _variants = doc['variants'];
    List<Map<String, dynamic>> variants =
        _variants?.map((x) => Map<String, dynamic>.from(x)).toList() ?? [];

    return Product(
      id: doc['id'],
      name: doc['name'],
      category: doc['category'],
      type: doc['type'],
      imageUrl: doc['imageUrl'],
      variants: variants.map((v) => Variant.fromMap(v)).toList(),
    );
  }
}

class Variant {
  String name;
  num price;
  num stock;

  Variant(this.name, this.price, this.stock);

  static String format(num price) {
    return NumberFormat.compactCurrency(locale: 'tl').format(price);
  }

  static Variant getLowestPrice(List<Variant> variants) {
    return variants
        .reduce((curr, next) => curr.price > next.price ? curr : next);
  }

  static Map<String, dynamic> toMap(Variant variant) {
    return <String, dynamic>{
      'name': variant.name,
      'price': variant.price,
      'stock': variant.stock,
    };
  }

  static Variant fromMap(Map<String, dynamic> doc) {
    return Variant(doc['name'], doc['price'], doc['stock']);
  }
}
