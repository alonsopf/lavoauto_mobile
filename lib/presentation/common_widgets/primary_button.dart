import 'package:flutter/material.dart';
import 'package:lavoauto/theme/app_color.dart';

import 'custom_text.dart';

class PrimaryButton {
  PrimaryButton._();

  static Widget primarybutton({onpressed, text, isPrimary = false, width, isEnable, progress, bool isCart = false}) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: WidgetStateProperty.all(2),
            minimumSize: WidgetStateProperty.all(Size(width, (isCart) ? 30 : 50)),
            shape: WidgetStateProperty.all(
                const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)))),
            backgroundColor: WidgetStateProperty.all((isEnable)
                ? (isPrimary)
                    ? AppColors.primary
                    : AppColors.secondary
                : AppColors.borderGrey)),
        onPressed: onpressed,
        child: progress ??
            CustomText(
              text: text,
              fontColor: (isEnable) ? AppColors.white : AppColors.grey,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
            ).setText());
  }

  static Widget secondarybutton({onpressed, text}) {
    return OutlinedButton(
        style: ButtonStyle(
            elevation: WidgetStateProperty.all(2),
            backgroundColor: WidgetStateProperty.all(AppColors.white),
            side: WidgetStateProperty.all(const BorderSide(color: AppColors.secondary, width: 2.0)),
            shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                side: BorderSide(color: AppColors.secondary, width: 2.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(12.0))))),
        onPressed: onpressed,
        child: CustomText(
          text: text,
          fontColor: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ).setText());
  }

  static Widget secondaryIconbutton({
    img,
    onpressed,
    text,
    color,
  }) {
    final effectiveColor = color ?? AppColors.secondary;

    return ElevatedButton.icon(
      onPressed: onpressed,
      icon: img ?? const SizedBox.shrink(),
      label: CustomText(
        text: text,
        fontColor: AppColors.white,
        fontWeight: FontWeight.w600,
        fontSize: 17.0,
      ).setText(),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: effectiveColor,
        foregroundColor: AppColors.white,
        shadowColor: AppColors.shadowLight,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: effectiveColor,
            width: 1.2,
          ),
        ),
        // Splash and overlay effects
        overlayColor: AppColors.white.withOpacity(0.08),
      ),
    );
  }
}
