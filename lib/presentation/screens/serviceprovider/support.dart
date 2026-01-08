import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/core/constants/app_strings.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/presentation/common_widgets/primary_button.dart';
import 'package:lavoauto/presentation/common_widgets/profile_image_widget.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../bloc/app_config/app_config_bloc.dart';
import '../../../dependencyInjection/di.dart';
import '../../../utils/marginUtils/margin_imports.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/custom_drawer.dart';

@RoutePage()
class ServiceProviderSupport extends StatefulWidget {
  const ServiceProviderSupport({super.key});

  @override
  State<ServiceProviderSupport> createState() => _ServiceProviderSupportState();
}

class _ServiceProviderSupportState extends State<ServiceProviderSupport> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  late final AppConfigBloc _appConfigBloc;
  String? _supportWhatsAppNumber;

  @override
  void initState() {
    super.initState();
    _appConfigBloc = AppContainer.getIt<AppConfigBloc>();
    _appConfigBloc.add(GetSupportInfoEvent());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    _appConfigBloc.close();
    super.dispose();
  }

  Future<void> _openWhatsApp() async {
    final message = _messageController.text.trim();
    final encodedMessage = Uri.encodeComponent(message);
    final whatsappNumber = _supportWhatsAppNumber ?? AppStrings.supportWhatsAppNumber;
    final whatsappUrl = 'https://wa.me/$whatsappNumber?text=$encodedMessage';

    try {
      final uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo abrir WhatsApp. Asegúrate de tenerlo instalado.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al intentar abrir WhatsApp'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppConfigBloc, AppConfigState>(
      bloc: _appConfigBloc,
      listener: (context, state) {
        if (state is SupportInfoLoaded) {
          setState(() {
            _supportWhatsAppNumber = state.supportInfo.supportWhatsAppNumber;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.screenBackgroundColor,
        appBar: CustomAppBar.getCustomBar(
          title: AppStrings.menuSupport,
          actions: [
            const HeaderProfileImage(),
          ],
        ),
        drawer: CustomDrawer(
          title: AppStrings.searchJobs,
          ontap: () {},
        ),
        body: GestureDetector(
          onTap: () {
            // Ocultar el keyboard cuando se toque fuera del campo de texto
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const YMargin(20),
                CustomText(
                  text: "¿Necesitas ayuda?",
                  fontSize: 28.0,
                  fontWeight: FontWeight.w800,
                  fontColor: AppColors.primary,
                ).setText(),
                const YMargin(10),
                Text(
                  "Escribe tu mensaje y nos pondremos en contacto contigo a través de WhatsApp.",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                const YMargin(22),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 18,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Tu mensaje",
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        fontColor: AppColors.primary,
                      ).setText(),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.greyLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderGrey),
                        ),
                        child: TextField(
                          controller: _messageController,
                          focusNode: _messageFocusNode,
                          maxLines: 8,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Escribe tu mensaje aquí...",
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 15,
                            ),
                            contentPadding: EdgeInsets.all(16),
                          ),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const YMargin(22),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton.primarybutton(
                    text: 'Enviar por WhatsApp',
                    onpressed: _openWhatsApp,
                    isPrimary: true,
                    width: double.infinity,
                    isEnable: true,
                  ),
                ),
                const YMargin(20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.secondary),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.support_agent_rounded, color: AppColors.secondary, size: 30),
                      const SizedBox(width: 14),
                      Expanded(
                        child: CustomText(
                          text:
                              "Te contactaremos al número: ${_supportWhatsAppNumber ?? AppStrings.supportWhatsAppNumber}",
                          maxLines: 3,
                          fontSize: 15.0,
                          fontColor: AppColors.primary,
                        ).setText(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
