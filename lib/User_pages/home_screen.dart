import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:breakfast_buddy/core/constants/app_colors.dart';
import 'package:breakfast_buddy/widgets/category_card.dart';
import 'package:breakfast_buddy/User_pages/categories_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 400),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildSearch(context),
              _buildFeaturedBanner(context),
              _buildCategories(context),
              _buildPopularProducts(context),
              _buildRecommendations(context),
            ],
          ),
        ),
      ),
    );
  }

  // Header
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.peach,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: const Icon(
              Icons.person,
              color: AppColors.primaryBrown,
              size: 27,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning, Sarah!',
                  style: GoogleFonts.outfit(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBrown,
                  ),
                ),
                Text(
                  "What's on your breakfast table?",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.mutedMocha,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => showMessage(context, 'Your cart is empty'),
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.primaryBrown,
              size: 25,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.white,
              side: const BorderSide(color: AppColors.inputBorder),
              fixedSize: const Size(46, 46),
            ),
          ),
        ],
      ),
    );
  }

  // Search
  Widget _buildSearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search croissants, coffee, pancakes...',
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppColors.mutedText,
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.mutedText),
          suffixIcon: IconButton(
            onPressed: () => showMessage(context, 'Search filters'),
            icon: const Icon(Icons.tune, color: AppColors.primaryBrown),
          ),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: AppColors.inputBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: AppColors.inputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: AppColors.orange),
          ),
        ),
      ),
    );
  }

  // Featured Banner
  Widget _buildFeaturedBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=900',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.75)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.peachLight,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                "CHEF'S MORNING SPECIAL",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBrown,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your Morning, Your Way',
              style: GoogleFonts.outfit(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            Text(
              'Handcrafted breakfast and morning brews',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => showMessage(context, 'Special offer selected'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: AppColors.white,
                shape: const StadiumBorder(),
              ),
              child: const Text('Order Special  →'),
            ),
          ],
        ),
      ),
    );
  }

  // Categories

  // Categories

  Widget _buildCategories(BuildContext context) {
    final categories = [
      {'name': 'Sweet Bakery', 'icon': Icons.bakery_dining},
      {'name': 'Savory & Toast', 'icon': Icons.egg_alt},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: GoogleFonts.outfit(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBrown,
                ),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CategoriesScreen()),
                  );
                },
                child: Text(
                  'See All',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 48,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CategoriesScreen()),
                  );
                },
                icon: Icon(
                  categories[index]['icon'] as IconData,
                  size: 18,
                  color: index == 0 ? AppColors.white : AppColors.orange,
                ),
                label: Text(categories[index]['name'] as String),
                style: OutlinedButton.styleFrom(
                  backgroundColor: index == 0
                      ? AppColors.orange
                      : AppColors.white,
                  foregroundColor: index == 0
                      ? AppColors.white
                      : AppColors.primaryBrown,
                  side: BorderSide(
                    color: index == 0
                        ? AppColors.orange
                        : AppColors.inputBorder,
                  ),
                  shape: const StadiumBorder(),
                  textStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Popular Products
  Widget _buildPopularProducts(BuildContext context) {
    final products = [
      {
        'name': 'Fluffy Buttermilk Pancakes',
        'description': 'Maple syrup & berries',
        'price': '\$9.50',
        'image':
            'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=500',
      },
      {
        'name': 'Artisan Brioche Sandwich',
        'description': 'Fresh breakfast sandwich',
        'price': '\$11.20',
        'image':
            'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=500',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Popular This Morning',
          'Freshly prepared cafe staples',
          context,
        ),
        SizedBox(
          height: 275,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final product = products[index];

              return Container(
                width: 220,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        product['image']!,
                        width: double.infinity,
                        height: 135,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 135,
                          color: AppColors.softCream,
                          child: const Icon(Icons.fastfood),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product['name']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBrown,
                      ),
                    ),
                    Text(
                      product['description']!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product['price']!,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBrown,
                          ),
                        ),
                        IconButton(
                          onPressed: () => showMessage(
                            context,
                            '${product['name']} added to cart',
                          ),
                          icon: const Icon(Icons.add),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.orange,
                            foregroundColor: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Recommendations
  Widget _buildRecommendations(BuildContext context) {
    final recommendations = [
      {
        'name': 'Morning Brew Duo',
        'description': 'Artisan espresso pairing',
        'price': '\$6.80',
        'rating': '4.9',
        'image':
            'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=300',
      },
      {
        'name': 'Almond Butter Croissant',
        'description': 'Toasted almonds & cream',
        'price': '\$5.40',
        'rating': '4.8',
        'image':
            'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=300',
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You Might Love',
            style: GoogleFonts.outfit(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBrown,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Curated for your palate',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 14),
          ...recommendations.map((product) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product['image']!,
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 75,
                        height: 75,
                        color: AppColors.softCream,
                        child: const Icon(Icons.fastfood),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: AppColors.honey,
                            ),
                            Text(
                              ' ${product['rating']}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBrown,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          product['name']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBrown,
                          ),
                        ),
                        Text(
                          product['description']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        Text(
                          product['price']!,
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBrown,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => showMessage(
                      context,
                      '${product['name']} added to cart',
                    ),
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.peachLight,
                      foregroundColor: AppColors.primaryBrown,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    String subtitle,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBrown,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
