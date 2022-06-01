import 'package:dm_delights/core/repository.dart';
import 'package:dm_delights/product/product.dart';
import 'package:flutter/cupertino.dart';

class ProductNotifier extends ChangeNotifier {
  final _repository = ProductRepository();
  late Future<List<Product>> _products;
  Future<List<Product>> get products => _products;

  ProductNotifier() {
    _products = _repository.fetch();
  }

  Future<Product?> fetchSingle(String id) {
    return _repository.fetchSingle(id);
  }

  Future<void> onRefresh() async {
    _products = _repository.fetch();
  }
}
