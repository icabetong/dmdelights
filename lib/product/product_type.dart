class ProductType {
  String id;
  String? name;
  String? avatar;

  ProductType(this.id, this.name, this.avatar);

  static fromMap(Map<String, dynamic> result) {
    return ProductType(result['id'], result['name'], result['avatar']);
  }
}
