import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/core/constants/app_strings.dart';
import 'package:lavoauto/features/pages/clothes/clothes_screen.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/presentation/common_widgets/primary_button.dart';
import 'package:lavoauto/presentation/router/router.gr.dart' as routeFiles;
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/marginUtils/margin_imports.dart';

import '../../../bloc/bloc/auth_bloc.dart';
import '../../../core/constants/assets.dart';

@RoutePage()
class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: -140,
            left: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withOpacity(0.25),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 3.2,
            right: -90,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -140,
            left: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withOpacity(0.25),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const YMargin(20.0),
                  Hero(
                    tag: 'app-logo',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.borderGrey),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadowLight,
                            blurRadius: 14,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset("assets/logo_white.png", height: 96, width: 96, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const YMargin(16.0),
                  CustomText(
                    text: AppStrings.welcome,
                    fontColor: AppColors.primary,
                    fontSize: 34.0,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w800,
                  ).setText(),
                  const YMargin(16.0),
                  CustomText(
                    text: AppStrings.welcomeMessage,
                    fontColor: AppColors.textSecondary,
                    fontSize: 16.0,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    height: 1.5,
                  ).setText(),
                  const YMargin(40.0),
                  CustomText(
                    text: AppStrings.register,
                    fontColor: AppColors.primary,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                  ).setText(),
                  const YMargin(10.0),
                  _buildChoiceButton(
                    title: AppStrings.user,
                    icon: Assets.personalInfo,
                    onTap: () {
                      context.read<AuthBloc>().add(const AuthInitialEvent());
                      context.router.push(const routeFiles.UserRegistrationInfoRoute());
                    },
                  ),
                  const YMargin(5.0),
                  _buildChoiceButton(
                    title: AppStrings.serviceProvider,
                    icon: Assets.serviceProvider,
                    onTap: () {
                      context.read<AuthBloc>().add(const AuthInitialEvent());
                      context.router.push(const routeFiles.ServiceProviderRegistrationInfoRoute());
                    },
                  ),
                  const YMargin(20.0),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton.primarybutton(
                      isEnable: true,
                      width: double.infinity,
                      text: AppStrings.login,
                      onpressed: () {
                        context.read<AuthBloc>().add(const AuthInitialEvent());
                        context.router.push(routeFiles.LoginRoute());
                      },
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: Column(
                      children: [
                        const YMargin(20.0),
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton.primarybutton(
                            isEnable: true,
                            isPrimary: true,
                            width: double.infinity,
                            text: "New Design",
                            onpressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ClothesScreen(),
                              ));
                            },
                          ),
                        ),
                        const YMargin(20.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceButton({
    required String title,
    required String icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Image.asset(
                icon,
                height: 26,
                width: 26,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomText(
                text: title,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                fontColor: AppColors.primary,
              ).setText(),
            ),
            const Icon(Icons.chevron_right, color: AppColors.primary, size: 30),
          ],
        ),
      ),
    );
  }
}
