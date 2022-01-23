class Category {
  String id;
  String name;
  String? imageUrl;
  List<String>? subcategories;

  Category(this.id, this.name, this.imageUrl, this.subcategories);

  static Category fromMap(Map<String, dynamic> doc) {
    final subcategories = doc['subcategories'];

    return Category(
      doc['id'],
      doc['name'],
      doc['imageUrl'],
      subcategories != null ? List<String>.from(subcategories) : [],
    );
  }
}
