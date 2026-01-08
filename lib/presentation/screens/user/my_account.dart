import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lavoauto/core/constants/app_strings.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/presentation/common_widgets/image_.dart';
import 'package:lavoauto/presentation/common_widgets/primary_button.dart';
import 'package:lavoauto/presentation/common_widgets/profile_image_widget.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

import '../../../core/constants/assets.dart';
import '../../../utils/marginUtils/margin_imports.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/custom_drawer.dart';

@RoutePage()
class MyAccount extends StatelessWidget {
  const MyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: CustomAppBar.getCustomBar(
        title: AppStrings.menuMyAccount,
        actions: [
          const HeaderProfileImage(),
        ],
      ),
      drawer: CustomDrawer(
        title: AppStrings.searchJobs,
        ontap: () {
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // children: [_buildCustomCard(context)],
        ),
      ),
    );
  }

  Widget _buildCustomCard(BuildContext context) {
    return Container(
      // height: 200.0,
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      width: Utils.getScreenSize(context).width,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: ColoredBox(
              color: AppColors.tertiary,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                titleAlignment: ListTileTitleAlignment.bottom,
                subtitle: CustomText(
                  text: "Juan P'erez",
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ).setText(),
                horizontalTitleGap: 10.0,
                leading: CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.screenBackgroundColor,
                  child: Image.asset(
                    Assets.placeholderUserPhoto,
                    height: 45.0,
                    width: 45.0,
                  ),
                ),
              ),
            ),
          ),
          ColoredBox(
            color: AppColors.greyNormalColor,
            child: ListTile(
              minTileHeight: 30.0,
              dense: true,
              minVerticalPadding: 0.0,
              horizontalTitleGap: 5.0,
              title: CustomText(
                text: AppStrings.exampleRequestDate,
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.w400,
              ).setText(),
              leading: CustomText(
                text: "${AppStrings.requestDate}:",
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.bold,
              ).setText(),
            ),
          ),
          ColoredBox(
            color: AppColors.white,
            child: ListTile(
              dense: true,
              minTileHeight: 30.0,
              minVerticalPadding: 0.0,
              horizontalTitleGap: 5.0,
              title: CustomText(
                text: AppStrings.exampleWeight,
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.w400,
              ).setText(),
              leading: CustomText(
                text: "${AppStrings.approxWeight}:",
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.bold,
              ).setText(),
            ),
          ),
          ColoredBox(
            color: AppColors.greyNormalColor,
            child: ListTile(
              minTileHeight: 30.0,
              dense: true,
              minVerticalPadding: 0.0,
              horizontalTitleGap: 5.0,
              title: CustomText(
                text: AppStrings.exampleOffer,
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.w400,
              ).setText(),
              leading: CustomText(
                text: "${AppStrings.offersAvailable}:",
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.bold,
              ).setText(),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0),
            ),
            child: ColoredBox(
              color: AppColors.greyColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: PrimaryButton.secondaryIconbutton(
                      color: AppColors.secondary,
                      text: AppStrings.viewDetail,
                      onpressed: () {
                        // context.router.push(const routeFiles.RegistrationRoute());
                      },
                    ),
                  ),
                  const XMargin(10.0),
                  PrimaryButton.secondaryIconbutton(
                    color: AppColors.primary,
                    text: AppStrings.offer,
                    onpressed: () {
                      // context.router.push(const routeFiles.RegistrationRoute());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
