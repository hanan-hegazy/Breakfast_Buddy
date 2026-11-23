import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundTop,
              AppColors.background,
              AppColors.backgroundBottom,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // SizedBox(height: 2), // Spacer for top padding
              // Top Label
              Container(
                margin: const EdgeInsets.only(top: 27),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.peach,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.peachBorder),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBrown.withOpacity(0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),

                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wb_sunny_outlined,
                      color: AppColors.primaryBrown,
                      size: 19,
                    ),
                    SizedBox(width: 11),
                    Text(
                      'Est. Fresh Mornings',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryBrown,
                      ),
                    ),
                  ],
                ),
              ),

              // Logo and App Name
              Column(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.logoBackground,
                      border: Border.all(color: AppColors.creamBorder),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.orange.withOpacity(0.06),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.bakery_dining,
                      size: 62,
                      color: AppColors.primaryBrown,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Breakfast Buddy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Make Every Morning Delicious',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      color: AppColors.secondaryText,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 5, color: AppColors.lightOrange),
                      SizedBox(width: 7),
                      Text(
                        'ARTISANAL BAKERY & CAFE',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 0.8,
                          color: AppColors.mutedText,
                        ),
                      ),
                      SizedBox(width: 7),
                      Icon(Icons.circle, size: 5, color: AppColors.lightOrange),
                    ],
                  ),
                ],
              ),

              // Animated Page Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _PageDot(color: AppColors.orange, index: 0),
                  const SizedBox(width: 9),
                  _PageDot(color: AppColors.honey, index: 1),
                  const SizedBox(width: 9),
                  _PageDot(color: AppColors.lightOrange, index: 2),
                ],
              ),

              // Bottom Coffee Label
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.softCream,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.creamBorder),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBrown.withOpacity(0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.coffee_outlined,
                      color: AppColors.primaryBrown,
                      size: 19,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'Waking up fresh coffee...',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Animated Page Indicators

class _PageDot extends StatefulWidget {
  final Color color;
  final int index;

  const _PageDot({required this.color, required this.index});

  @override
  State<_PageDot> createState() => _PageDotState();
}

class _PageDotState extends State<_PageDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double progress = (_controller.value - widget.index * 0.18) % 1.0;

        double movement = 0;

        if (progress < 0.35) {
          movement = -6 * (progress / 0.35);
        } else if (progress < 0.7) {
          movement = -6 + (6 * (progress - 0.35) / 0.35);
        }

        return Transform.translate(offset: Offset(0, movement), child: child);
      },
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}
