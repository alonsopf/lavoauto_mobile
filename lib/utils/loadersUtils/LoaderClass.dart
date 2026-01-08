import 'dart:async';
import 'package:lavoauto/theme/app_color.dart';
import 'package:flutter/material.dart';
import '/presentation/common_widgets/custom_text.dart';
import 'three_arched_circle.dart';

class Loader {
  static OverlayEntry overlayEntry(BuildContext context,
      {var text = "", var color = false}) {
    if (!context.mounted) throw Exception('Context is not mounted');
    
    OverlayEntry loader = OverlayEntry(
        builder: (context) => Center(
              child: Material(
                color: color
                    ? AppColors.white
                    : AppColors.greyNormalColor.withOpacity(0.4),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ThreeArchedCircle(
                        color: AppColors.primaryColor,
                        size: 50,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomText(
                        text: text,
                        textAlign: TextAlign.center,
                        fontSize: 18.0,
                        fontColor: AppColors.primaryColor,
                      ).setText(),
                    ],
                  ),
                ),
              ),
            ));
    return loader;
  }

  static hideLoader(OverlayEntry loader) {
    try {
      if (loader.mounted) {
        loader.remove();
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          if (loader.mounted) {
            loader.remove();
          }
        } catch (_) {}
      });
      Timer(const Duration(milliseconds: 100), () {
        try {
          if (loader.mounted) {
            loader.remove();
          }
        } catch (_) {}
      });
    } catch (_) {}
  }

  static getLoader(BuildContext context) => overlayEntry(context);
  static insertLoader(BuildContext context, loader) {
    if (!context.mounted) return;
    try {
      if (loader.mounted) return;
      Overlay.of(context).insert(loader);
    } catch (_) {}
  }

  static loadingProcess(BuildContext context) async {
    var loader = Loader.getLoader(context);
    Loader.insertLoader(context, loader);
    await Future.delayed(const Duration(seconds: 1));
    Loader.hideLoader(loader);
  }
}
