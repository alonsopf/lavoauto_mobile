import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lavoauto/presentation/screens/auth/privacy_policy_screen.dart';
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
                      ..onTap = () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PrivacyPolicyScreen(
                              isUser: isUser,
                              showPrivacyPolicy: true,
                            ),
                          ),
                        );
                      },
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
                      ..onTap = () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PrivacyPolicyScreen(
                              isUser: isUser,
                              showPrivacyPolicy: false,
                            ),
                          ),
                        );
                      },
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
