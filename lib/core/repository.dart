import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dm_delights/cart/cart_item.dart';
import 'package:dm_delights/category/category.dart';
import 'package:dm_delights/core/infrastructure.dart';
import 'package:dm_delights/orders/order.dart';
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

  Future<Product?> fetchSingle(String productId) async {
    final result = await firestore
        .collection(_name)
        .where('id', isEqualTo: productId)
        .get();

    if (result.docs.isNotEmpty) {
      return Product.fromMap(result.docs[0].data());
    }

    return Future.value();
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

  Future<void> reset() async {
    final userId = auth.currentUser?.uid;
    if (userId != null) {
      final result = await firestore
          .collection(_users)
          .doc(userId)
          .collection(_cart)
          .get();

      for (QueryDocumentSnapshot doc in result.docs) {
        await doc.reference.delete();
      }
    }
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

class OrderRepository extends Repository<Order> {
  static const _orders = "orders";
  static const _users = "users";
  static const _cart = "cart";
  final auth = Infrastructure.auth;
  final firestore = Infrastructure.firestore;

  @override
  Future<List<Order>> fetch() async {
    final userId = auth.currentUser?.uid;
    if (userId != null) {
      final result = await firestore
          .collection(_orders)
          .where('ownerId', isEqualTo: userId)
          .get();

      return List.from(result.docs.map((c) => Order.fromMap(c.data())));
    }

    return [];
  }

  Future<void> insert(Order order) async {
    final userId = auth.currentUser?.uid;
    if (userId != null) {
      final batch = firestore.batch();
      batch.set(
        firestore.collection(_orders).doc(order.id),
        Order.toMap(order),
      );

      final items = await firestore
          .collection(_users)
          .doc(userId)
          .collection(_cart)
          .get();
      for (QueryDocumentSnapshot snapshot in items.docs) {
        batch.delete(snapshot.reference);
      }

      return await batch.commit();
    }
    return;
  }
}
