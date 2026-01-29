import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lavoauto/data/models/privacy_policy.dart';
import 'package:lavoauto/theme/app_color.dart';

class PrivacyPolicyCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final bool isUser;

  const PrivacyPolicyCheckbox({
    Key? key,
    required this.isChecked,
    required this.onChanged,
    required this.isUser,
  }) : super(key: key);

  void _showPolicyModal(BuildContext context, {required bool showPrivacyPolicy}) {
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: AppColors.screenBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header con título y botón X
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // Spacer para centrar título
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            // Contenido scrolleable
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
                        style: const TextStyle(
                          color: AppColors.blackNormalColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: isChecked,
          onChanged: onChanged,
          activeColor: AppColors.secondary,
          checkColor: AppColors.white,
          visualDensity: VisualDensity.compact,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
                children: [
                  const TextSpan(text: "He leído y acepto las "),
                  TextSpan(
                    text: "Políticas de Privacidad",
                    style: const TextStyle(
                      color: AppColors.white,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showPolicyModal(context, showPrivacyPolicy: true),
                  ),
                  const TextSpan(text: " y "),
                  TextSpan(
                    text: "Condiciones de Uso",
                    style: const TextStyle(
                      color: AppColors.white,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showPolicyModal(context, showPrivacyPolicy: false),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
