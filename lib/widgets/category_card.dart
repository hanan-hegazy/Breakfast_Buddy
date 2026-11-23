import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:breakfast_buddy/core/constants/app_colors.dart';

class CategoryCard extends StatefulWidget {
  final String title;
  final int? itemCount;
  final String badge;
  final String description;
  final String imageUrl;
  final String buttonText;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    this.itemCount,
    required this.badge,
    required this.description,
    required this.imageUrl,
    required this.buttonText,
    this.onTap,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool isFavorite = false;

  Widget _buildImagePlaceholder() {
    return Container(
      height: 190,
      width: double.infinity,
      color: AppColors.peach,
      child: const Icon(
        Icons.restaurant,
        size: 55,
        color: AppColors.primaryBrown,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.peachBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBrown.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
                child: widget.imageUrl.isNotEmpty
                    ? Image.network(
                        widget.imageUrl,
                        height: 190,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildImagePlaceholder();
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return _buildImagePlaceholder();
                        },
                      )
                    : _buildImagePlaceholder(),
              ),

              // Badge
              if (widget.badge.isNotEmpty)
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.badge,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBrown,
                      ),
                    ),
                  ),
                ),

              // Favorite Button
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : AppColors.primaryBrown,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Category Details
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: GoogleFonts.outfit(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryBrown,
                        ),
                      ),
                    ),

                    if (widget.itemCount != null)
                      Text(
                        '${widget.itemCount} Items',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mutedText,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  widget.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 1.6,
                    color: AppColors.secondaryText,
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: widget.onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBrown,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.buttonText,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 17),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
