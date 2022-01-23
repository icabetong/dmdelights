class Product {
  String id;
  String name;
  num price;
  String category;
  String type;

  Product(this.id, this.name, this.price, this.category, this.type);

  bool isCorrectType(String type) {
    return this.type.toLowerCase() == type.toLowerCase();
  }

  static Product fromMap(Map<String, dynamic> doc) {
    return Product(
      doc['id'],
      doc['name'],
      doc['price'],
      doc['category'],
      doc['type'],
    );
  }
}
