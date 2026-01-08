import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/bloc/user_info_bloc.dart';
import 'package:lavoauto/bloc/worker/jobsearch/jobsearch_bloc.dart';
import 'package:lavoauto/core/constants/app_strings.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/presentation/common_widgets/image_.dart';
import 'package:lavoauto/presentation/router/router.gr.dart' as routeFiles;
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/marginUtils/margin_imports.dart';
import 'package:lavoauto/utils/utils.dart';

import '../../core/constants/assets.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.ontap, required this.title, this.isUser});
  final String title;

  final bool? isUser;
  final VoidCallback ontap;

  /// Get user type from shared preferences
  bool get _isUserType {
    // If isUser is explicitly set, use that value (for backward compatibility)
    if (isUser != null) return isUser!;

    // Otherwise, get from shared preferences automatically
    bool isClient = Utils.isClientUser();
    debugPrint("🔍 Auto-detected user type - isClient: $isClient (${Utils.getAuthenticationUser()})");

    return isClient;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      backgroundColor: AppColors.primary.withOpacity(0.95),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 20),
            if (_isUserType) ...[
              BlocBuilder<UserInfoBloc, UserInfoState>(
                buildWhen: (previous, current) => current is UserInfoSuccess,
                builder: (context, state) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 54,
                          width: 54,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.25),
                          ),
                          child: const Icon(Icons.person, color: Colors.white, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: (state is UserInfoSuccess)
                                    ? "${state.userWorkerInfo?.data?.nombre ?? ''} ${state.userWorkerInfo?.data?.apellidos ?? ''}"
                                    : "Unknown",
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontColor: AppColors.white,
                                textAlign: TextAlign.center,
                              ).setText(),
                              const YMargin(4),
                              CustomText(
                                text: (state is UserInfoSuccess)
                                    ? "${state.userWorkerInfo?.data?.email ?? ''}"
                                    : "unknown@gmail.com",
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                fontColor: AppColors.white,
                                textAlign: TextAlign.center,
                              ).setText(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
                color: Colors.white.withOpacity(0.25),
              ),
            ],
            ListTile(
              horizontalTitleGap: 0.0,
              minVerticalPadding: 10.0,
              leading:
                  ImagesPng.assetPNG(_isUserType ? Assets.newRequest : Assets.searchJob, height: 24.0, width: 24.0),
              title: CustomText(
                text: _isUserType ? AppStrings.newOrder : AppStrings.searchJobs,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontColor: AppColors.white,
                textAlign: TextAlign.left,
              ).setText(),
              onTap: () {
                // context.router.maybePop();
                if (_isUserType) {
                  context.router.popAndPush(routeFiles.NewOrder());
                  return;
                }
                // Reset jobsearch state before navigating to prevent loading issues
                context.read<JobsearchBloc>().add(const ResetJobsearchStateEvent());
                context.router.popAndPush(const routeFiles.JobSearch());
              },
            ),
            ListTile(
              horizontalTitleGap: 0.0,
              minVerticalPadding: 10.0,
              leading: ImagesPng.assetPNG(Assets.myServices, height: 24.0, width: 24.0),
              title: CustomText(
                text: _isUserType ? AppStrings.menuMyOrders : AppStrings.myServices,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontColor: AppColors.white,
                textAlign: TextAlign.left,
              ).setText(),
              onTap: () {
                if (_isUserType) {
                  context.router.popAndPush(const routeFiles.MyOrders());
                  return;
                }
                context.router.popAndPush(const routeFiles.MyServices());
              },
            ),
            ListTile(
              horizontalTitleGap: 0.0,
              minVerticalPadding: 10.0,
              leading: ImagesPng.assetPNG(Assets.personalInfo, height: 24.0, width: 24.0),
              title: CustomText(
                text: _isUserType ? AppStrings.menuMyAccount : AppStrings.personalInfo,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontColor: AppColors.white,
                textAlign: TextAlign.left,
              ).setText(),
              onTap: () {
                context.router.popAndPush(const routeFiles.UserProviderPersonalInfo());
                return;
              },
            ),
            // Finanzas - solo mostrar para usuarios, ocultar para prestadores de servicio
            if (_isUserType) ...[
              ListTile(
                horizontalTitleGap: 0.0,
                minVerticalPadding: 10.0,
                leading: ImagesPng.assetPNG(Assets.paymentMethod, height: 24.0, width: 24.0),
                title: CustomText(
                  text: AppStrings.menuPaymentMethods,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontColor: AppColors.white,
                  textAlign: TextAlign.left,
                ).setText(),
                onTap: () {
                  context.router.popAndPush(const routeFiles.PaymentMethods());
                },
              ),
            ],
            ListTile(
              horizontalTitleGap: 0.0,
              minVerticalPadding: 10.0,
              leading: ImagesPng.assetPNG(Assets.support, height: 24.0, width: 24.0),
              title: CustomText(
                text: AppStrings.menuSupport,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontColor: AppColors.white,
                textAlign: TextAlign.left,
              ).setText(),
              onTap: () {
                context.router.popAndPush(const routeFiles.ServiceProviderSupport());
              },
            ),
            ListTile(
              horizontalTitleGap: 0.0,
              minVerticalPadding: 10.0,
              leading: ImagesPng.assetPNG(Assets.logout, height: 24.0, width: 24.0),
              title: CustomText(
                text: AppStrings.logout,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontColor: AppColors.white,
                textAlign: TextAlign.left,
              ).setText(),
              onTap: () async {
                await Utils.sharedpref?.clear();
                if (context.mounted) {
                  context.router.replaceAll([routeFiles.LoginRoute()]);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
