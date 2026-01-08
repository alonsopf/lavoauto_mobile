import 'package:flutter/services.dart';
import '../../theme/app_color.dart';
import '/presentation/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomAppBar {
  CustomAppBar._();

  static getCustomBar(
      {leadingWidget,
      actions,
      title = '',
      bool bgColor = false,
      centerTitle = false}) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,

      actions: actions,

      titleSpacing: 0,
      title: CustomText(
              text: title,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontColor: AppColors.white)
          .setText(),

      centerTitle: true,
      toolbarHeight: 60,
       backgroundColor: AppColors.primary,
    );
  }
}
