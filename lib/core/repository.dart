import 'package:dm_delights/core/supabase.dart';
import 'package:dm_delights/category/category.dart';

abstract class Repository<T> {
  Future<List<T>> fetch();
}

class CategoryRepository extends Repository<Category> {
  static const _name = "categories";

  @override
  Future<List<Category>> fetch() async {
    final response = await Backend.instance.from(_name).select().execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      return List<Category>.from(results.map((d) => Category.fromMap(d)));
    }

    return [];
  }
}
