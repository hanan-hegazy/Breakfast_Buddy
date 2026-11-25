import 'package:flutter/material.dart';

import 'package:breakfast_buddy/core/constants/app_colors.dart';
import 'package:breakfast_buddy/core/services/product_service.dart';
import 'package:breakfast_buddy/models/product_model.dart';
import 'package:breakfast_buddy/widgets/product_card.dart';
import 'package:breakfast_buddy/User_pages/product_details_screen.dart';

class ProductsScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductService _productService = const ProductService();
  final TextEditingController _searchController = TextEditingController();

  String searchQuery = '';
  String selectedSubCategory = 'all';

  final Map<String, String> subCategoryNames = {
    'pancakes': 'Pancakes',
    'bakery': 'Bakery',
    'cookies': 'Cookies',
    'drinks': 'Drinks',
    'sandwiches': 'Sandwiches',
    'healthy': 'Healthy',
    'eggs': 'Eggs',
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String getSubCategoryName(String value) {
    return subCategoryNames[value] ?? value;
  }

  List<ProductModel> filterProducts(List<ProductModel> products) {
    return products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      final matchesSubCategory =
          selectedSubCategory == 'all' ||
          product.subCategory == selectedSubCategory;

      return matchesSearch && matchesSubCategory;
    }).toList();
  }

  void _openProductDetails(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primaryBrown,
            size: 20,
          ),
        ),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: AppColors.primaryBrown,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cart will be connected later')),
              );
            },
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.primaryBrown,
            ),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Find your favorite breakfast',
                  style: TextStyle(
                    color: AppColors.darkText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Choose something delicious for your morning.',
                  style: TextStyle(color: AppColors.mutedText, fontSize: 13),
                ),

                const SizedBox(height: 18),

                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: const TextStyle(
                      color: AppColors.mutedText,
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.secondaryText,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.peachBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.peachBorder,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.orange,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<List<ProductModel>>(
              stream: _productService.getProductsByCategory(widget.categoryId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.orange),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Something went wrong while loading products.',
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                  );
                }

                final products = snapshot.data ?? [];

                if (products.isEmpty) {
                  return const Center(
                    child: Text(
                      'No products available yet.',
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                  );
                }

                final subCategories =
                    products
                        .map((product) => product.subCategory)
                        .where((value) => value.isNotEmpty)
                        .toSet()
                        .toList()
                      ..sort();

                final filteredProducts = filterProducts(products);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 43,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          _buildFilterChip('all', 'All'),

                          ...subCategories.map(
                            (subCategory) => _buildFilterChip(
                              subCategory,
                              getSubCategoryName(subCategory),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                      child: Text(
                        '${filteredProducts.length} Products',
                        style: const TextStyle(
                          color: AppColors.primaryBrown,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Expanded(
                      child: filteredProducts.isEmpty
                          ? const Center(
                              child: Text(
                                'No products found.',
                                style: TextStyle(color: AppColors.mutedText),
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              itemCount: filteredProducts.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 14,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.67,
                                  ),
                              itemBuilder: (context, index) {
                                final product = filteredProducts[index];

                                return GestureDetector(
                                  onTap: () {
                                    _openProductDetails(product);
                                  },
                                  child: ProductCard(
                                    product: product,
                                    onAddToCart: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${product.name} will be added to cart',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = selectedSubCategory == value;

    return Padding(
      padding: const EdgeInsets.only(right: 9),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            selectedSubCategory = value;
          });
        },
        backgroundColor: AppColors.white,
        selectedColor: AppColors.orange,
        side: BorderSide(
          color: isSelected ? AppColors.orange : AppColors.peachBorder,
        ),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.white : AppColors.secondaryText,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
    );
  }
}
