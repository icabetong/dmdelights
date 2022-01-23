import 'package:dm_delights/category/category.dart';

abstract class Repository<T> {
  Future<List<T>> fetch();
}

class CategoryRepository extends Repository<Category> {
  static const _name = "categories";

  @override
  Future<List<Category>> fetch() async {
    return [];
  }
}
