import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/assets.dart';
import '../../../theme/app_color.dart';
import '../../../utils/marginUtils/margin_imports.dart';
import '../../../utils/utils.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/custom_drawer.dart';
import '../../common_widgets/custom_text.dart';
import '../../common_widgets/image_.dart';
import 'package:lavoauto/presentation/common_widgets/profile_image_widget.dart';

@RoutePage()
class Finances extends StatelessWidget {
  const Finances({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: CustomAppBar.getCustomBar(
        title: AppStrings.finances,
        actions: [
          const HeaderProfileImage(),
        ],
      ),
      drawer: CustomDrawer(
        title: AppStrings.myServices,
        ontap: () {
          debugPrint("click ");
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: ListView(
          children: [
            const YMargin(16.0),
            _buildCustomCardWidget(context,
                title: AppStrings.currentPaymentCycle,
                subtitle: AppStrings.exampleFinanceDate),
            const YMargin(16.0),
            _buildCustomCard(
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomCardWidget(BuildContext context,
      {String title = '', subtitle = ''}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      width: Utils.getScreenSize(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: AppStrings.currentPaymentCycle,
            fontSize: 22.0,
            fontColor: AppColors.primary,
            fontWeight: FontWeight.w500,
          ).setText(),
          SizedBox(
            width: Utils.getScreenSize(context).width,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              color: AppColors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: CustomText(
                  text: subtitle,
                  fontSize: 22.0,
                  fontColor: AppColors.grey,
                  fontWeight: FontWeight.bold,
                ).setText(),
              ),
            ),
          ),
          const YMargin(10.0),
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: AppStrings.estimatedPayment,
                    fontSize: 22.0,
                    fontColor: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ).setText(),
                  SizedBox(
                    width: Utils.getScreenSize(context).width,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      color: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: CustomText(
                          textAlign: TextAlign.end,
                          text: AppStrings.exampleprice,
                          fontSize: 22.0,
                          fontColor: AppColors.grey,
                          fontWeight: FontWeight.bold,
                        ).setText(),
                      ),
                    ),
                  ),
                ],
              )),
              const XMargin(10.0),
              Expanded(
                  child: Column(
                children: [
                  CustomText(
                    text: AppStrings.paymentDate,
                    fontSize: 22.0,
                    fontColor: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ).setText(),
                  SizedBox(
                    width: Utils.getScreenSize(context).width,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      color: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: CustomText(
                          text: AppStrings.exampleDate,
                          fontSize: 22.0,
                          textAlign: TextAlign.end,
                          fontColor: AppColors.grey,
                          fontWeight: FontWeight.bold,
                        ).setText(),
                      ),
                    ),
                  ),
                ],
              ))
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCustomCard(BuildContext context) {
    return ExpansionTile(
      iconColor: AppColors.white,
      visualDensity: VisualDensity.comfortable,
      collapsedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      backgroundColor: AppColors.secondary,
      collapsedBackgroundColor: AppColors.secondary,
      title: CustomText(
        text: AppStrings.paymentBreakdown,
        fontSize: 22.0,
        fontColor: AppColors.primary,
        fontWeight: FontWeight.bold,
      ).setText(),
      children: List.generate(
          1,
          (v) => Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                ),
                width: Utils.getScreenSize(context).width,
                child: Column(children: [
                  const YMargin(10.0),
                  ListTile(
                    dense: true,
                    minTileHeight: 10.0,
                    horizontalTitleGap: 5.0,
                    leading: CustomText(
                      text: AppStrings.orderBreakdown,
                      fontSize: 22.0,
                      fontColor: AppColors.grey,
                      fontWeight: FontWeight.bold,
                    ).setText(),
                  ),
                  const YMargin(10.0),
                  ...List.generate(
                    4,
                    (index) => ListTile(
                      dense: true,
                      minTileHeight: 10.0,
                      minLeadingWidth: 20.0,
                      horizontalTitleGap: 20,
                      title: CustomText(
                        text: "\$100",
                        fontSize: 22.0,
                        fontColor: AppColors.grey,
                        fontWeight: FontWeight.bold,
                      ).setText(),
                      leading: CustomText(
                        text:
                            "${index + 1}) ${AppStrings.exampleOrderId} #${index + 1 * 400} =>  ",
                        fontSize: 22.0,
                        fontColor: AppColors.grey,
                        fontWeight: FontWeight.bold,
                      ).setText(),
                    ),
                  ),
                  const Divider(
                    thickness: 4.0,
                    color: AppColors.grey,
                    height: 20,
                  ),
                  ListTile(
                    dense: true,
                    minTileHeight: 10.0,
                    minLeadingWidth: 20.0,
                    horizontalTitleGap: 10,
                    trailing: CustomText(
                      text: "\$500",
                      fontSize: 22.0,
                      fontColor: AppColors.grey,
                      fontWeight: FontWeight.bold,
                    ).setText(),
                    title: CustomText(
                      text: AppStrings.subtotal,
                      fontSize: 22.0,
                      fontColor: AppColors.grey,
                      fontWeight: FontWeight.bold,
                    ).setText(),
                  ),
                  ListTile(
                    dense: true,
                    minTileHeight: 10.0,
                    minLeadingWidth: 20.0,
                    horizontalTitleGap: 10,
                    trailing: CustomText(
                      text: "\$0.0",
                      fontSize: 22.0,
                      fontColor: AppColors.grey,
                      fontWeight: FontWeight.bold,
                    ).setText(),
                    title: CustomText(
                      text: AppStrings.commission,
                      fontSize: 22.0,
                      fontColor: AppColors.grey,
                      fontWeight: FontWeight.bold,
                    ).setText(),
                  ),
                  ListTile(
                    dense: true,
                    minTileHeight: 10.0,
                    minLeadingWidth: 20.0,
                    horizontalTitleGap: 10,
                    trailing: CustomText(
                      text: "\$500.0",
                      fontSize: 22.0,
                      fontColor: AppColors.grey,
                      fontWeight: FontWeight.bold,
                    ).setText(),
                    title: CustomText(
                      text: AppStrings.netPayment,
                      fontSize: 22.0,
                      fontColor: AppColors.grey,
                      fontWeight: FontWeight.bold,
                    ).setText(),
                  ),
                ]),
              )),
    );
  }
}
