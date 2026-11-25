import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:breakfast_buddy/models/product_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Map<String, CartItem> _items = {};

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _cartSubscription;

  bool isLoading = true;
  String? errorMessage;

  Map<String, CartItem> get items => Map.unmodifiable(_items);

  int get itemCount {
    return _items.values.fold(0, (total, item) => total + item.quantity);
  }

  double get totalPrice {
    return _items.values.fold(0, (total, item) => total + item.totalPrice);
  }

  CartProvider() {
    _authSubscription = _auth.authStateChanges().listen(_onAuthChanged);
  }

  CollectionReference<Map<String, dynamic>> _cartCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('cart');
  }

  void _onAuthChanged(User? user) {
    _cartSubscription?.cancel();
    _items.clear();
    errorMessage = null;

    if (user == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    _cartSubscription = _cartCollection(user.uid).snapshots().listen(
      (snapshot) {
        _items.clear();

        for (final doc in snapshot.docs) {
          final data = doc.data();

          final product = ProductModel(
            id: data['productId'] ?? doc.id,
            name: data['name'] ?? '',
            description: data['description'] ?? '',
            price: (data['price'] as num?)?.toDouble() ?? 0.0,
            imageUrl: data['imageUrl'] ?? '',
            categoryId: data['categoryId'] ?? '',
            subCategory: data['subCategory'] ?? '',
            isAvailable: data['isAvailable'] ?? true,
          );

          final quantity = (data['quantity'] as num?)?.toInt() ?? 1;

          _items[doc.id] = CartItem(product: product, quantity: quantity);
        }

        isLoading = false;
        errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        isLoading = false;
        errorMessage = 'Could not load your cart.';
        notifyListeners();
      },
    );
  }

  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Please log in to add items to your cart.');
    }

    if (quantity < 1) return;

    final cartDocument = _cartCollection(user.uid).doc(product.id);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(cartDocument);

      if (snapshot.exists) {
        final currentQuantity =
            (snapshot.data()?['quantity'] as num?)?.toInt() ?? 0;

        transaction.update(cartDocument, {
          'quantity': currentQuantity + quantity,
        });
      } else {
        transaction.set(cartDocument, {
          'productId': product.id,
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'categoryId': product.categoryId,
          'subCategory': product.subCategory,
          'isAvailable': product.isAvailable,
          'quantity': quantity,
        });
      }
    });
  }

  Future<void> increaseQuantity(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final document = _cartCollection(user.uid).doc(productId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(document);

      if (!snapshot.exists) return;

      final quantity = (snapshot.data()?['quantity'] as num?)?.toInt() ?? 1;

      transaction.update(document, {'quantity': quantity + 1});
    });
  }

  Future<void> decreaseQuantity(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final document = _cartCollection(user.uid).doc(productId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(document);

      if (!snapshot.exists) return;

      final quantity = (snapshot.data()?['quantity'] as num?)?.toInt() ?? 1;

      if (quantity <= 1) {
        transaction.delete(document);
      } else {
        transaction.update(document, {'quantity': quantity - 1});
      }
    });
  }

  Future<void> removeFromCart(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _cartCollection(user.uid).doc(productId).delete();
  }

  Future<void> clearCart() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _cartCollection(user.uid).get();

    final batch = _firestore.batch();

    for (final document in snapshot.docs) {
      batch.delete(document.reference);
    }

    await batch.commit();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _cartSubscription?.cancel();
    super.dispose();
  }
}
