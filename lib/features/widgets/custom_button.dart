import 'package:flutter/material.dart';
import 'package:lavoauto/theme/app_color.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isPrimary;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isPrimary = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        backgroundColor: isOutlined
            ? Colors.transparent
            : isPrimary
                ? AppColors.primaryNew
                : Colors.grey.shade200,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isOutlined == true
                ? AppColors.primaryNew
                : isPrimary
                    ? AppColors.primaryNew
                    : Colors.grey.shade200,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: isPrimary ? FontWeight.bold : FontWeight.w500,
          color: isOutlined
              ? AppColors.primaryNew
              : isPrimary
                  ? Colors.white
                  : Colors.black,
        ),
      ),
    );
  }
}
