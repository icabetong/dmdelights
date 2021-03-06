import 'package:dm_delights/category/category.dart';
import 'package:dm_delights/core/repository.dart';
import 'package:flutter/widgets.dart';

class CategoryNotifier extends ChangeNotifier {
  final _repository = CategoryRepository();
  late Future<List<Category>> _categories;
  Future<List<Category>> get categories => _categories;

  CategoryNotifier() {
    _categories = _repository.fetch();
  }

  Future<void> refresh() async {
    _categories = _repository.fetch();
    notifyListeners();
  }
}
