class Category {
  String id;
  String? name;
  String? avatar;

  Category(this.id, this.name, this.avatar);

  static fromMap(Map<String, dynamic> result) {
    return Category(result['id'], result['name'], result['avatar']);
  }
}
