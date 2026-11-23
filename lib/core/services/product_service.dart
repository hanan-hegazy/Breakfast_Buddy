import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:breakfast_buddy/models/product_model.dart';

class ProductService {
  const ProductService();

  Stream<List<ProductModel>> getProductsByCategory(String categoryId) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                return ProductModel.fromMap(doc.id, doc.data());
              })
              .where((product) => product.isAvailable)
              .toList();
        });
  }
}
