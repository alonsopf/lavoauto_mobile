import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../theme/app_color.dart';
import 'custom_text.dart';

class CustomCard {
  CustomCard();

  static Widget customCardWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
          child: CustomText(
            text: AppStrings.appName_,
            fontColor: AppColors.white,
            fontSize: 36.0,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ).setText(),
        ),
      ),
    );
  }
}
