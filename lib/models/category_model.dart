class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String badge;
  final bool isActive;
  final int sortOrder;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.badge,
    required this.isActive,
    required this.sortOrder,
  });

  factory CategoryModel.fromMap(String id, Map<String, dynamic> data) {
    return CategoryModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      badge: data['badge'] ?? '',
      isActive: data['isActive'] ?? true,
      sortOrder: (data['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }
}
