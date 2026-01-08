import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/bloc/user_info_bloc.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class EditServicesPage extends StatefulWidget {
  const EditServicesPage({super.key});

  @override
  State<EditServicesPage> createState() => _EditServicesPageState();
}

class _EditServicesPageState extends State<EditServicesPage> {
  // Service options
  bool ofreceLavado = true;
  bool ofreceLavadoYSecado = false;
  bool ofreceLavadoSecadoYPlanchado = false;

  // Text controllers
  final TextEditingController _horariosController = TextEditingController();
  final TextEditingController _zonaController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Load user info to get profile photo
    final token = Utils.getAuthenticationToken();
    if (token.isNotEmpty) {
      context.read<UserInfoBloc>().add(FetchUserProfileInfoEvent(token: token));
    }
    // TODO: Load current service data from API
    _precioController.text = "0.00";
  }

  @override
  void dispose() {
    _horariosController.dispose();
    _zonaController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  void _saveServices() async {
    setState(() => _isSubmitting = true);

    // TODO: Implement API call to save services
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Servicios actualizados exitosamente'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Perfil del Lavador",
          style: TextStyle(
            color: AppColors.primaryNewDark,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                // Profile photo
                Center(
                  child: BlocBuilder<UserInfoBloc, UserInfoState>(
                    builder: (context, state) {
                      String? photoUrl;
                      if (state is UserInfoSuccess && state.userWorkerInfo?.data != null) {
                        photoUrl = state.userWorkerInfo!.data!.fotoUrl;
                      }

                      return Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.borderGrey,
                          border: Border.all(
                            color: AppColors.borderGrey,
                            width: 3,
                          ),
                        ),
                        child: photoUrl != null && photoUrl.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  photoUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    );
                                  },
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              ),
                      );
                    },
                  ),
                ),
            const SizedBox(height: 30),
            // Servicios que ofrece
            const Text(
              "Servicios que ofrece",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 16),
            _checkboxOption(
              label: "Lavado",
              value: ofreceLavado,
              onChanged: (val) {
                setState(() {
                  ofreceLavado = val ?? false;
                });
              },
            ),
            const SizedBox(height: 12),
            _checkboxOption(
              label: "Lavado y secado",
              value: ofreceLavadoYSecado,
              onChanged: (val) {
                setState(() {
                  ofreceLavadoYSecado = val ?? false;
                });
              },
            ),
            const SizedBox(height: 12),
            _checkboxOption(
              label: "Lavado, secado y planchado",
              value: ofreceLavadoSecadoYPlanchado,
              onChanged: (val) {
                setState(() {
                  ofreceLavadoSecadoYPlanchado = val ?? false;
                });
              },
            ),
            const SizedBox(height: 30),
            // Horarios disponibles
            _textField(
              controller: _horariosController,
              label: "Horarios disponibles",
              hint: "Ej: 8:00 AM - 6:00 PM",
            ),
            const SizedBox(height: 20),
            // Zona de recolección
            _textField(
              controller: _zonaController,
              label: "Zona de recolección",
              hint: "Ej: Centro, Norte, Sur",
            ),
            const SizedBox(height: 30),
            // Precio base
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Precio base",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: _precioController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                    decoration: const InputDecoration(
                      prefixText: '\$',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Guardar button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNew,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _isSubmitting ? null : _saveServices,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        "Guardar",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _checkboxOption({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: value ? AppColors.primaryNew : AppColors.borderGrey,
                width: 2,
              ),
              color: value ? AppColors.primaryNew : Colors.transparent,
            ),
            child: value
                ? const Icon(
                    Icons.check,
                    size: 18,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.grey.withOpacity(0.5)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderGrey, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderGrey, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryNew, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}

