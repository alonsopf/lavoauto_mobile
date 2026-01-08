import 'package:flutter/material.dart';
import 'package:lavoauto/theme/app_color.dart';

class CustomOrderStepper extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const CustomOrderStepper({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: List.generate(steps.length, (index) {
            final bool isActive = index == currentStep;
            final bool isCompleted = index < currentStep;

            return Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? AppColors.primaryNew : Colors.white,
                    border: Border.all(
                      width: 3,
                      color: AppColors.primaryNew,
                    ),
                  ),
                ),
                if (index < steps.length - 1)
                  Container(
                    width: 3,
                    height: 30,
                    color: AppColors.primaryNew.withOpacity(
                      isCompleted ? 0.8 : 0.3,
                    ),
                  ),
              ],
            );
          }),
        ),
        const SizedBox(width: 18),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(steps.length, (index) {
            final bool isActive = index == currentStep;

            return Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: isActive ? AppColors.primaryNew : Colors.black87,
                ),
                child: Text(steps[index]),
              ),
            );
          }),
        )
      ],
    );
  }
}
