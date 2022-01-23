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

  static Variant getLowestPrice(List<Variant> variants) {
    return variants
        .reduce((curr, next) => curr.price > next.price ? curr : next);
  }

  static Variant fromMap(Map<String, dynamic> doc) {
    return Variant(doc['name'], doc['price'], doc['stock']);
  }
}
