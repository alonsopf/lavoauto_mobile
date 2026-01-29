import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/bloc/user_info_bloc.dart';
import 'package:lavoauto/data/repositories/worker_repo.dart';
import 'package:lavoauto/data/models/request/worker/update_worker_info_modal.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class CuentaBancariaPage extends StatefulWidget {
  const CuentaBancariaPage({super.key});

  @override
  State<CuentaBancariaPage> createState() => _CuentaBancariaPageState();
}

class _CuentaBancariaPageState extends State<CuentaBancariaPage> {
  final TextEditingController _clabeController = TextEditingController();
  bool _isLoading = false;
  bool _hasPrePopulated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prePopulateFields();
    });
  }

  @override
  void dispose() {
    _clabeController.dispose();
    super.dispose();
  }

  void _prePopulateFields() {
    if (_hasPrePopulated) return;

    final userInfoState = context.read<UserInfoBloc>().state;
    if (userInfoState is UserInfoSuccess && userInfoState.userWorkerInfo?.data != null) {
      final data = userInfoState.userWorkerInfo!.data!;
      setState(() {
        _clabeController.text = data.clabe ?? '';
        _hasPrePopulated = true;
      });
    }
  }

  Future<void> _saveCLABE() async {
    if (_isLoading) return;

    final clabe = _clabeController.text.trim();

    // Validate CLABE (18 digits)
    if (clabe.isNotEmpty && clabe.length != 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La CLABE debe tener 18 dígitos'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String token = Utils.getAuthenticationToken();
      if (token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: No se encontró token de autenticación'),
            backgroundColor: AppColors.error,
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      final userInfoState = context.read<UserInfoBloc>().state;
      if (userInfoState is! UserInfoSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Información de usuario no disponible'),
            backgroundColor: AppColors.error,
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      final data = userInfoState.userWorkerInfo!.data!;
      final workerRepo = WorkerRepo();
      final updateRequest = UpdateWorkerInfoRequest(
        token: token,
        body: UpdateWorkerInfoBody(
          nombre: data.nombre ?? '',
          apellidos: data.apellidos ?? '',
          rfc: data.rfc ?? '',
          clabe: clabe,
          calle: data.calle ?? '',
          numeroExterior: data.numeroexterior ?? '',
          numeroInterior: data.numerointerior ?? '',
          colonia: data.colonia ?? '',
          ciudad: data.ciudad ?? '',
          estado: data.estado ?? '',
          codigoPostal: data.codigoPostal ?? '',
          lat: data.lat ?? 0.0,
          lon: data.lon ?? 0.0,
          fotoURL: data.fotoUrl,
        ),
      );

      final response = await workerRepo.updateWorkerInfo(updateRequest);
      if (response.data != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('CLABE actualizada exitosamente'),
            backgroundColor: AppColors.success,
          ),
        );
        context.read<UserInfoBloc>().add(FetchUserProfileInfoEvent(token: token));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.errorMessage ?? 'No se pudo actualizar'}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
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
          "Cuenta bancaria",
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
            // Info card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryNew.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primaryNew,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Tu CLABE se usa para recibir los pagos por tus servicios.",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryNewDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // CLABE input
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "CLABE Interbancaria",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryNewDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "18 dígitos",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _clabeController,
                    keyboardType: TextInputType.number,
                    maxLength: 18,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: "Ej: 012345678901234567",
                      filled: true,
                      fillColor: AppColors.bgColor,
                      counterText: "",
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      prefixIcon: const Icon(Icons.account_balance, color: AppColors.grey),
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNew,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _isLoading ? null : _saveCLABE,
                child: _isLoading
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
}
