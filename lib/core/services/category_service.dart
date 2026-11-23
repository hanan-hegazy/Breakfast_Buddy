import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:breakfast_buddy/models/category_model.dart';

class CategoryService {
  const CategoryService();

  Stream<List<CategoryModel>> getCategories() {
    return FirebaseFirestore.instance
        .collection('categories')
        .orderBy('sortOrder')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                return CategoryModel.fromMap(doc.id, doc.data());
              })
              .where((category) => category.isActive)
              .toList();
        });
  }
}
