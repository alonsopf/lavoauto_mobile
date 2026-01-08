import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lavoauto/data/models/privacy_policy.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/theme/app_color.dart';

@RoutePage()
class PrivacyPolicyScreen extends StatelessWidget {
  final bool isUser;
  final bool showPrivacyPolicy; // true for privacy, false for terms

  const PrivacyPolicyScreen({
    Key? key,
    required this.isUser,
    required this.showPrivacyPolicy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title;
    String content;

    if (showPrivacyPolicy) {
      title = "Políticas de Privacidad";
      content = isUser 
          ? PrivacyPolicyData.userPrivacyPolicy 
          : PrivacyPolicyData.providerPrivacyPolicy;
    } else {
      title = "Condiciones de Uso";
      content = isUser 
          ? PrivacyPolicyData.userTermsOfService 
          : PrivacyPolicyData.providerTermsOfService;
    }

    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackgroundColor,
        title: CustomText(
          text: title,
          fontColor: AppColors.primary,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ).setText(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Text(
                      content,
                      style: TextStyle(
                        color: AppColors.blackNormalColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        height: 1.5, // Mejor espaciado entre líneas
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 