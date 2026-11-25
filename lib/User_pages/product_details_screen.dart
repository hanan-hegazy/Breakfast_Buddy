
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:breakfast_buddy/core/constants/app_colors.dart';
import 'package:breakfast_buddy/models/product_model.dart';
import 'package:breakfast_buddy/providers/cart_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  bool isFavorite = false;
  bool isAddingToCart = false;

  double get totalPrice => widget.product.price * quantity;

  String get categoryName {
    return widget.product.categoryId == 'sweet'
        ? 'Sweet Breakfast'
        : 'Savory Breakfast';
  }

  void increaseQuantity() {
    if (quantity < 99) {
      setState(() {
        quantity++;
      });
    }
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  Future<void> addToCart() async {
    if (isAddingToCart) return;

    setState(() {
      isAddingToCart = true;
    });

    try {
      await context.read<CartProvider>().addToCart(
        widget.product,
        quantity: quantity,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.product.name} x $quantity added to cart',
          ),
          backgroundColor: AppColors.primaryBrown,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Exception: ', ''),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isAddingToCart = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primaryBrown,
          ),
        ),
        title: Text(
          'Product Details',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.darkText,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: Icon(
              isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: AppColors.orange,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildImagePlaceholder();
                        },
                      )
                    : _buildImagePlaceholder(),
              ),
            ),

            const SizedBox(height: 20),

            // Product Information
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBrown.withOpacity(0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.peach,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      categoryName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Name and Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkText,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        '${product.price.toStringAsFixed(0)} EGP',
                        style: GoogleFonts.outfit(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: AppColors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Description
                  Text(
                    product.description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      height: 1.7,
                      color: AppColors.secondaryText,
                    ),
                  ),

                  const SizedBox(height: 26),

                  // Quantity and Add to Cart
                  Row(
                    children: [
                      Container(
                        height: 54,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.softCream,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            _quantityButton(
                              icon: Icons.remove,
                              onTap: decreaseQuantity,
                              enabled: quantity > 1,
                            ),

                            SizedBox(
                              width: 34,
                              child: Text(
                                '$quantity',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryBrown,
                                ),
                              ),
                            ),

                            _quantityButton(
                              icon: Icons.add,
                              onTap: increaseQuantity,
                              enabled: quantity < 99,
                              isAdd: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed:
                                isAddingToCart ? null : addToCart,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orange,
                              foregroundColor: AppColors.white,
                              disabledBackgroundColor:
                                  AppColors.lightOrange,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: isAddingToCart
                                ? const SizedBox(
                                    width: 21,
                                    height: 21,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.shopping_bag_outlined,
                                        size: 19,
                                      ),

                                      const SizedBox(width: 7),

                                      Flexible(
                                        child: Text(
                                          'Add to Cart',
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Total Price
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Total: ${totalPrice.toStringAsFixed(0)} EGP',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
    bool isAdd = false,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isAdd ? AppColors.orange : AppColors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: isAdd
              ? AppColors.white
              : AppColors.primaryBrown,
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.peachLight,
      child: const Center(
        child: Icon(
          Icons.breakfast_dining,
          size: 65,
          color: AppColors.secondaryText,
        ),
      ),
    );
  }
}
