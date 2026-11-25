
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final String subCategory;
  final bool isAvailable;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.subCategory,
    required this.isAvailable,
  });

  factory ProductModel.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return ProductModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] ?? '',
      categoryId: data['categoryId'] ?? '',
      subCategory: data['subCategory'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
    );
  }
}
