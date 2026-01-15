import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/bloc/user_info_bloc.dart';
import 'package:lavoauto/data/repositories/worker_repo.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class PrecioKmPage extends StatefulWidget {
  const PrecioKmPage({super.key});

  @override
  State<PrecioKmPage> createState() => _PrecioKmPageState();
}

class _PrecioKmPageState extends State<PrecioKmPage> {
  final TextEditingController _precioKmController = TextEditingController();
  bool _isLoading = false;
  double _currentPrecioKm = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCurrentPrecioKm();
  }

  @override
  void dispose() {
    _precioKmController.dispose();
    super.dispose();
  }

  void _loadCurrentPrecioKm() {
    final userInfoState = context.read<UserInfoBloc>().state;
    if (userInfoState is UserInfoSuccess && userInfoState.userWorkerInfo?.data != null) {
      final precioKm = userInfoState.userWorkerInfo!.data!.precioKm ?? 0.0;
      setState(() {
        _currentPrecioKm = precioKm;
        _precioKmController.text = precioKm.toStringAsFixed(2);
      });
    }
  }

  Future<void> _savePrecioKm() async {
    if (_isLoading) return;

    final precioKmText = _precioKmController.text.trim();
    if (precioKmText.isEmpty) {
      _showMessage('Por favor ingresa un precio', isError: true);
      return;
    }

    final precioKm = double.tryParse(precioKmText);
    if (precioKm == null || precioKm < 0) {
      _showMessage('Por favor ingresa un precio válido', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      String token = Utils.getAuthenticationToken();
      if (token.isEmpty) {
        _showMessage('Error: No se encontró token de autenticación', isError: true);
        setState(() => _isLoading = false);
        return;
      }

      final workerRepo = WorkerRepo();
      final response = await workerRepo.updatePrecioKm(token: token, precioKm: precioKm);

      if (response.data != null) {
        _showMessage('Precio por KM actualizado exitosamente');
        // Refresh user info
        context.read<UserInfoBloc>().add(FetchUserProfileInfoEvent(token: token));
        setState(() => _currentPrecioKm = precioKm);
      } else {
        _showMessage('Error: ${response.errorMessage ?? 'No se pudo actualizar'}', isError: true);
      }
    } catch (e) {
      _showMessage('Error: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
      ),
    );
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
          "Precio por KM",
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
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryNew.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryNew.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primaryNew,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Este es el precio que cobrarás por cada kilómetro de distancia al cliente',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryNewDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Current price display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Precio Actual',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${_currentPrecioKm.toStringAsFixed(2)} MXN/km',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryNew,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Input section
            const Text(
              "Nuevo Precio por KM",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _precioKmController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                hintText: 'Ej: 5.50',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 16, right: 12),
                  child: Text(
                    '\$ ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryNewDark,
                    ),
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                suffixText: 'MXN/km',
                suffixStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey,
                ),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              ),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 40),
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
                onPressed: _isLoading ? null : _savePrecioKm,
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
