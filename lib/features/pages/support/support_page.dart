import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/app_config/app_config_bloc.dart';
import 'package:lavoauto/core/constants/app_strings.dart';
import 'package:lavoauto/dependencyInjection/di.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
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
        appBar: AppBar(
          backgroundColor: AppColors.primaryNew,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Ayuda y Soporte',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: false,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "¿Necesitas ayuda?",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryNewDark,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Escribe tu mensaje y nos pondremos en contacto contigo a través de WhatsApp.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 22),
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
                      const Text(
                        "Tu mensaje",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryNewDark,
                        ),
                      ),
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
                            color: AppColors.primaryNewDark,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _openWhatsApp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryNew,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Enviar por WhatsApp',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                        child: Text(
                          "Te contactaremos al número: ${_supportWhatsAppNumber ?? AppStrings.supportWhatsAppNumber}",
                          maxLines: 3,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.primaryNewDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
