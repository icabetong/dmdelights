import 'package:dm_delights/category/category.dart';
import 'package:dm_delights/core/infrastructure.dart';
import 'package:dm_delights/product/product.dart';

abstract class Repository<T> {
  Future<List<T>> fetch();
}

class CategoryRepository extends Repository<Category> {
  static const _name = "categories";
  final firestore = Infrastructure.firestore;

  @override
  Future<List<Category>> fetch() async {
    final result = await firestore.collection(_name).get();
    return List.from(result.docs.map((e) => Category.fromMap(e.data())));
  }
}

class ProductRepository extends Repository<Product> {
  static const _name = "products";
  final firestore = Infrastructure.firestore;

  @override
  Future<List<Product>> fetch() async {
    final result = await firestore.collection(_name).get();
    return List.from(result.docs.map((e) => Product.fromMap(e.data())));
  }

  Future<List<Product>> fetchWithCategory(String categoryId) async {
    final result = await firestore
        .collection(_name)
        .where('category', isEqualTo: categoryId)
        .get();

    return List.from(result.docs.map((e) => Product.fromMap(e.data())));
  }
}
