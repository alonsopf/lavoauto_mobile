import 'package:flutter/material.dart';
import 'package:lavoauto/theme/app_color.dart';

class CustomScaffold extends StatelessWidget {
  final Widget? child;
  final Widget? titleWidget;
  final String? title;
  const CustomScaffold({super.key, required this.child, this.titleWidget, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNewHeader,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  titleWidget ??
                      Text(
                        title ?? "LAVOAUTO",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(26),
                    topRight: Radius.circular(26),
                  ),
                ),
                child: SingleChildScrollView(child: child),
              ),
            )
          ],
        ),
      ),
    );
  }
}
