import 'package:dm_delights/core/supabase.dart';
import 'package:dm_delights/product/product_type.dart';

abstract class Repository<T> {
  Future<List<T>> fetch();
}

class ProductTypeRepository extends Repository<ProductType> {
  static const _name = "type";

  @override
  Future<List<ProductType>> fetch() async {
    final response = await Backend.instance.from(_name).select().execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      return List<ProductType>.from(results.map((d) => ProductType.fromMap(d)));
    }

    return [];
  }
}
