import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CustomFieldLabel extends StatelessWidget {
  final String text;

  const CustomFieldLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.primaryBrown,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
