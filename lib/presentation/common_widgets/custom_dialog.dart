import '../../theme/app_color.dart';
import '../../utils/marginUtils/margin_imports.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import 'custom_text.dart';

class DialogCustom {
  const DialogCustom();

  Future<dynamic> getCustomDialog(Widget? icon,
      {String title = '',
      String subtitle = '',
      double fontSize = 0.0,
      isBack = false,
      color,
      onCancel,
      onSuccess,
      bool onuserCheckIn = false,
      bool onlogout = false,
      bool cancelEnable = true,
      required BuildContext context}) async {
    if (!context.mounted) return;
    
    Size deviceSize = Utils.getScreenSize(context);
    await showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Center(
            child: Container(
              height: deviceSize.height * 0.26,
              // constraints: BoxConstraints(
              //   minHeight: deviceSize.height * 0.24,
              //   maxHeight: deviceSize.height * 0.25,
              // ),
              width: deviceSize.width * 0.9,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: isBack,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            splashRadius: 0.01,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close))
                      ],
                    ),
                  ),
                  const YMargin(10),
                  CustomText(
                          text: title,
                          maxLines: 1,
                          fontColor:
                              color ?? AppColors.black,
                          textAlign: TextAlign.left,
                          letterSpacing: 0.5,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold)
                      .setText(),
                  Visibility(
                    visible: subtitle.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: CustomText(
                              text: subtitle,
                              maxLines: 3,
                              fontColor:
                                  color ?? AppColors.black,
                              textAlign: TextAlign.left,
                              letterSpacing: 0.5,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500)
                          .setText(),
                    ),
                  ),
                  const YMargin(10),
                  Row(
                    mainAxisAlignment: cancelEnable
                        ? MainAxisAlignment.spaceEvenly
                        : MainAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Visibility(
                        visible: cancelEnable,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: const BorderSide(
                                      color:
                                          AppColors.borderGrey,
                                      width: 2.0))),
                              backgroundColor: const WidgetStatePropertyAll(
                                  AppColors.white)),
                          onPressed: onCancel,
                          child: CustomText(
                                  text: "Cancelar",
                                  maxLines: 1,
                                  fontColor:
                                      color ?? AppColors.black,
                                  textAlign: TextAlign.center,
                                  letterSpacing: 0.5,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500)
                              .setText(),
                        ),
                      )),
                      const XMargin(20),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: onSuccess,
                        style: ButtonStyle(
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0))),
                            backgroundColor: const WidgetStatePropertyAll(
                                AppColors.primary)),
                        child: CustomText(
                                text: "OK",
                                maxLines: 3,
                                fontColor:
                                    color ?? AppColors.white,
                                textAlign: TextAlign.center,
                                letterSpacing: 0.5,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold)
                            .setText(),
                      )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
