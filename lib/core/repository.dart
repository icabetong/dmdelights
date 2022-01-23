import 'package:dm_delights/cart/cart_item.dart';
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

class CartRepository extends Repository<CartItem> {
  static const _users = "users";
  static const _cart = "cart";
  final firestore = Infrastructure.firestore;
  final auth = Infrastructure.auth;

  Future<void> insert(CartItem cartItem) async {
    final userId = auth.currentUser?.uid;
    if (userId != null) {
      final ref = firestore
          .collection(_users)
          .doc(userId)
          .collection(_cart)
          .doc(cartItem.id);
      ref.set(CartItem.toMap(cartItem));
    }

    return;
  }

  Future<void> update(CartItem cartItem) async {
    final userId = auth.currentUser?.uid;
    if (userId != null) {
      final ref = firestore
          .collection(_users)
          .doc(userId)
          .collection(_cart)
          .doc(cartItem.id);
      ref.update(CartItem.toMap(cartItem));
    }
  }

  Future<void> remove(CartItem cartItem) async {
    final userId = auth.currentUser?.uid;
    if (userId != null) {
      return await firestore
          .collection(_users)
          .doc(userId)
          .collection(_cart)
          .doc(cartItem.id)
          .delete();
    }
    return;
  }

  @override
  Future<List<CartItem>> fetch() async {
    final userId = auth.currentUser?.uid;
    if (userId != null) {
      final result = await firestore
          .collection(_users)
          .doc(userId)
          .collection(_cart)
          .get();

      return List.from(result.docs.map((c) => CartItem.fromMap(c.data())));
    }

    return [];
  }
}
