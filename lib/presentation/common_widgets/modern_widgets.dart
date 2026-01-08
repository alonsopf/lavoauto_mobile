import 'package:flutter/material.dart';
import '../../theme/app_color.dart';
import 'custom_text.dart';

/// Modern UI widgets for the redesigned Lavoauto app
/// Based on the new design specifications with cleaner cards and better spacing

class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  
  const ModernCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20.0),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.borderGrey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class ModernButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isSelected;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  
  const ModernButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.isSelected = false,
    this.icon,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected 
            ? AppColors.secondary 
            : (isPrimary ? AppColors.secondary : AppColors.white),
        foregroundColor: isSelected 
            ? AppColors.white 
            : (isPrimary ? AppColors.white : AppColors.primary),
        elevation: 0,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
            color: isSelected ? AppColors.secondary : AppColors.borderGrey,
            width: 2.0,
          ),
        ),
      ),
      onPressed: onPressed,
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon!,
                const SizedBox(width: 8.0),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: isSelected 
                        ? AppColors.white 
                        : (isPrimary ? AppColors.white : AppColors.primary),
                  ),
                ),
              ],
            )
          : Text(
              text,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: isSelected 
                    ? AppColors.white 
                    : (isPrimary ? AppColors.white : AppColors.primary),
              ),
            ),
    );
  }
}

class ModernCategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  
  const ModernCategoryButton({
    Key? key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary.withOpacity(0.1) : AppColors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.borderGrey,
            width: isSelected ? 2.5 : 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 40.0,
              color: isSelected ? AppColors.secondary : AppColors.primary,
            ),
            const SizedBox(height: 12.0),
            CustomText(
              text: label,
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              fontColor: isSelected ? AppColors.primary : AppColors.blackNormalColor,
              textAlign: TextAlign.center,
            ).setText(),
          ],
        ),
      ),
    );
  }
}

class ModernRadioOption<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final String label;
  final String? sublabel;
  final ValueChanged<T?>? onChanged;
  
  const ModernRadioOption({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.label,
    this.sublabel,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;
    
    return InkWell(
      onTap: () => onChanged?.call(value),
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary.withOpacity(0.1) : AppColors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.borderGrey,
            width: isSelected ? 2.5 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.secondary : AppColors.borderGrey,
                  width: 2.0,
                ),
                color: isSelected ? AppColors.secondary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.circle,
                      size: 12.0,
                      color: AppColors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: label,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    fontColor: isSelected ? AppColors.primary : AppColors.blackNormalColor,
                  ).setText(),
                  if (sublabel != null) ...[
                    const SizedBox(height: 4.0),
                    CustomText(
                      text: sublabel!,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      fontColor: AppColors.grey,
                    ).setText(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModernProviderCard extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final double rating;
  final String price;
  final bool isVerified;
  final String? guaranteedDelivery;
  final VoidCallback? onTap;
  
  const ModernProviderCard({
    Key? key,
    this.photoUrl,
    required this.name,
    required this.rating,
    required this.price,
    this.isVerified = false,
    this.guaranteedDelivery,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: AppColors.borderGrey,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Profile Image
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: photoUrl != null && photoUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.person,
                          size: 32.0,
                          color: AppColors.secondary,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 32.0,
                      color: AppColors.secondary,
                    ),
            ),
            const SizedBox(width: 16.0),
            // Provider Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          text: name,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          fontColor: AppColors.primary,
                        ).setText(),
                      ),
                      CustomText(
                        text: price,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontColor: AppColors.primary,
                      ).setText(),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  if (isVerified) ...[
                    CustomText(
                      text: 'Verificada',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      fontColor: AppColors.grey,
                    ).setText(),
                    const SizedBox(height: 4.0),
                  ],
                  if (guaranteedDelivery != null) ...[
                    CustomText(
                      text: guaranteedDelivery!,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      fontColor: AppColors.grey,
                    ).setText(),
                    const SizedBox(height: 4.0),
                  ],
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < rating.floor() ? Icons.star : Icons.star_border,
                          size: 16.0,
                          color: AppColors.secondary,
                        );
                      }),
                      const SizedBox(width: 4.0),
                      CustomText(
                        text: rating.toStringAsFixed(1),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        fontColor: AppColors.primary,
                      ).setText(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModernSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  
  const ModernSectionHeader({
    Key? key,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            fontColor: AppColors.primary,
          ).setText(),
          if (subtitle != null) ...[
            const SizedBox(height: 8.0),
            CustomText(
              text: subtitle!,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              fontColor: AppColors.grey,
            ).setText(),
          ],
        ],
      ),
    );
  }
}

