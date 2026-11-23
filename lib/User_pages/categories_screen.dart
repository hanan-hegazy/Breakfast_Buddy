import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:breakfast_buddy/core/constants/app_colors.dart';
import 'package:breakfast_buddy/core/services/category_service.dart';
import 'package:breakfast_buddy/models/category_model.dart';
import 'package:breakfast_buddy/widgets/category_card.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  final CategoryService _categoryService = CategoryService();

  void _openCategory(BuildContext context, CategoryModel category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${category.name} selected'),
        backgroundColor: AppColors.primaryBrown,
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
        centerTitle: false,
        title: Text(
          'Categories',
          style: GoogleFonts.outfit(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryBrown,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find Your Perfect Breakfast',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.darkText,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              'Explore our delicious breakfast collections.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.secondaryText,
              ),
            ),

            const SizedBox(height: 24),

            StreamBuilder<List<CategoryModel>>(
              stream: _categoryService.getCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(
                        color: AppColors.primaryBrown,
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Something went wrong while loading categories.',
                    ),
                  );
                }

                final categories = snapshot.data ?? [];

                if (categories.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Text('No categories available yet.'),
                    ),
                  );
                }

                return Column(
                  children: categories.map((category) {
                    return CategoryCard(
                      title: category.name,
                      badge: category.badge,
                      description: category.description,
                      imageUrl: category.imageUrl,
                      buttonText: 'Explore ${category.name.split(' ').first}',
                      onTap: () {
                        _openCategory(context, category);
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
