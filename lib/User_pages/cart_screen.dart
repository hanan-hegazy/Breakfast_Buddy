import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:breakfast_buddy/core/constants/app_colors.dart';
import 'package:breakfast_buddy/providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _confirmClearCart(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text(
            'Clear your bag?',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              color: AppColors.darkText,
            ),
          ),
          content: Text(
            'All items will be removed from your breakfast bag.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.secondaryText,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.secondaryText),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Clear', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm == true && context.mounted) {
      await context.read<CartProvider>().clearCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final items = cartProvider.items.values.toList();

        return Scaffold(
          backgroundColor: AppColors.background,

          appBar: AppBar(
            backgroundColor: AppColors.background,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: AppColors.primaryBrown),
            ),
            title: Column(
              children: [
                Text(
                  'Your Breakfast Bag',
                  style: GoogleFonts.outfit(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText,
                  ),
                ),
                Text(
                  'Your morning order',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              if (items.isNotEmpty)
                TextButton(
                  onPressed: () => _confirmClearCart(context),
                  child: Text(
                    'Clear',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.orange,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
            ],
          ),

          body: cartProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.orange),
                )
              : cartProvider.errorMessage != null
              ? _buildError(cartProvider.errorMessage!)
              : items.isEmpty
              ? _buildEmptyCart(context)
              : _buildFilledCart(context, cartProvider, items),

          bottomNavigationBar:
              !cartProvider.isLoading &&
                  cartProvider.errorMessage == null &&
                  items.isNotEmpty
              ? _buildBottomBar(context, cartProvider)
              : null,
        );
      },
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 170,
              height: 170,
              decoration: const BoxDecoration(
                color: AppColors.peach,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 85,
                color: AppColors.primaryBrown,
              ),
            ),

            const SizedBox(height: 28),

            Text(
              'Your breakfast bag is empty',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: AppColors.darkText,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Looks like you haven’t added anything yet. '
              'Let’s find something delicious for your morning.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.7,
                color: AppColors.secondaryText,
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Explore Morning Menu',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilledCart(
    BuildContext context,
    CartProvider provider,
    List<CartItem> items,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Morning Picks',
                style: GoogleFonts.outfit(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.peach,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  '${provider.itemCount} items',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBrown,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            'Everything you picked for your breakfast.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.secondaryText,
            ),
          ),

          const SizedBox(height: 20),

          ...items.map((item) => _buildCartItem(context, provider, item)),

          const SizedBox(height: 12),

          _buildOrderSummary(provider),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    CartProvider provider,
    CartItem item,
  ) {
    final product = item.product;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBrown.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 92,
              height: 105,
              child: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _imagePlaceholder();
                      },
                    )
                  : _imagePlaceholder(),
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkText,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        provider.removeFromCart(product.id);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: AppColors.mutedText,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    height: 1.5,
                    color: AppColors.secondaryText,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${product.price.toStringAsFixed(0)} EGP',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.orange,
                      ),
                    ),

                    Container(
                      height: 34,
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: AppColors.softCream,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          _quantityButton(
                            icon: Icons.remove,
                            onTap: () {
                              provider.decreaseQuantity(product.id);
                            },
                          ),

                          SizedBox(
                            width: 27,
                            child: Text(
                              '${item.quantity}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryBrown,
                              ),
                            ),
                          ),

                          _quantityButton(
                            icon: Icons.add,
                            isAdd: true,
                            onTap: () {
                              provider.increaseQuantity(product.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isAdd = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isAdd ? AppColors.orange : AppColors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 15,
          color: isAdd ? AppColors.white : AppColors.primaryBrown,
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.darkText,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.secondaryText,
                ),
              ),
              Text(
                '${provider.totalPrice.toStringAsFixed(0)} EGP',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: AppColors.creamBorder),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: GoogleFonts.outfit(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText,
                ),
              ),
              Text(
                '${provider.totalPrice.toStringAsFixed(0)} EGP',
                style: GoogleFonts.outfit(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppColors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CartProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBrown.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        height: 54,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_back, size: 18),
              const SizedBox(width: 8),
              Text(
                'Continue Shopping',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.secondaryText,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: AppColors.peachLight,
      child: const Center(
        child: Icon(
          Icons.breakfast_dining,
          size: 38,
          color: AppColors.secondaryText,
        ),
      ),
    );
  }
}
