import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lavoauto/bloc/order_flow/order_flow_bloc.dart';
import 'package:lavoauto/bloc/order_flow/order_flow_state.dart';
import 'package:lavoauto/data/models/lavador_cercano_model.dart';
import 'package:lavoauto/data/repositories/orden_repository.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';
import 'package:lavoauto/core/config/injection.dart';

class ConfirmarOrdenPage extends StatefulWidget {
  final LavadorCercano lavador;
  final int vehiculoClienteId;
  final String vehiculoInfo;

  const ConfirmarOrdenPage({
    super.key,
    required this.lavador,
    required this.vehiculoClienteId,
    required this.vehiculoInfo,
  });

  @override
  State<ConfirmarOrdenPage> createState() => _ConfirmarOrdenPageState();
}

class _ConfirmarOrdenPageState extends State<ConfirmarOrdenPage> {
  final OrdenRepository _ordenRepository = getIt<OrdenRepository>();

  DateTime? _fechaEsperada;
  bool _lavadorOcupado = false;
  bool _isLoadingStatus = true;
  bool _isCreatingOrder = false;
  final _notasController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default date to tomorrow
    _fechaEsperada = DateTime.now().add(const Duration(days: 1));
    _checkLavadorStatus();
  }

  @override
  void dispose() {
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _checkLavadorStatus() async {
    setState(() {
      _isLoadingStatus = true;
    });

    try {
      final response =
          await _ordenRepository.getLavadorOrdenesActivas(widget.lavador.lavadorId);

      if (response.data != null) {
        setState(() {
          _lavadorOcupado = response.data!.tieneActivas;
          _isLoadingStatus = false;
        });
      } else {
        setState(() {
          _isLoadingStatus = false;
        });
      }
    } catch (e) {
      print('Error checking lavador status: $e');
      setState(() {
        _isLoadingStatus = false;
      });
    }
  }

  Future<void> _selectFechaEsperada() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaEsperada ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryNew,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.primaryNewDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _fechaEsperada = picked;
      });
    }
  }

  Future<void> _confirmarOrden() async {
    if (_fechaEsperada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona una fecha esperada'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isCreatingOrder = true;
    });

    try {
      final token = Utils.getAuthenticationToken();
      final fechaISO = _fechaEsperada!.toIso8601String();

      final response = await _ordenRepository.crearOrden(
        token: token,
        lavadorId: widget.lavador.lavadorId,
        vehiculoClienteId: widget.vehiculoClienteId,
        fechaEsperada: fechaISO,
        distanciaKm: widget.lavador.distanciaKm,
        notasCliente: _notasController.text.trim().isEmpty
            ? null
            : _notasController.text.trim(),
      );

      setState(() {
        _isCreatingOrder = false;
      });

      if (response.data != null) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Orden creada exitosamente'),
              backgroundColor: AppColors.success,
            ),
          );

          // Navigate back to home or orders page
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.errorMessage ?? 'Error al crear la orden'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isCreatingOrder = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final precioBase = 0.0; // TODO: Get from servicio if needed
    final precioDistancia = widget.lavador.distanciaKm * widget.lavador.precioKm;
    final precioTotal = precioBase + precioDistancia;

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
          "Confirmar Orden",
          style: TextStyle(
            color: AppColors.primaryNewDark,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
      ),
      body: _isLoadingStatus
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.white,
                    child: Column(
                      children: [
                        const Text(
                          'Paso 3 de 3: Confirma tu orden',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.directions_car,
                              size: 18,
                              color: AppColors.primaryNew,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                widget.vehiculoInfo,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primaryNewDark,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Lavador info card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: AppColors.borderGrey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            // Lavador photo (large)
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppColors.primaryNew.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primaryNew,
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors.primaryNew,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Name
                            Text(
                              widget.lavador.nombreCompleto,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryNewDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            // Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 20,
                                  color: Colors.amber[700],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.lavador.calificacionPromedio
                                      .toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Distance info
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 18,
                                  color: Colors.blue[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.lavador.distanciaFormateada,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.grey,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.access_time,
                                  size: 18,
                                  color: Colors.orange[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.lavador.duracionFormateada,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                            // Status badge
                            if (_lavadorOcupado) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange[50],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.orange[300]!,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 18,
                                      color: Colors.orange[700],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Actualmente realizando un servicio',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.orange[700],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Precio desglosado
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: AppColors.borderGrey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Desglose de Precios',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryNewDark,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Tarifa base
                            _buildPrecioRow(
                              'Tarifa base',
                              '\$${precioBase.toStringAsFixed(2)}',
                              isSubtotal: true,
                            ),
                            const SizedBox(height: 12),
                            // Distancia
                            _buildPrecioRow(
                              'Distancia (${widget.lavador.distanciaKm.toStringAsFixed(1)} km × \$${widget.lavador.precioKm.toStringAsFixed(2)}/km)',
                              '\$${precioDistancia.toStringAsFixed(2)}',
                              isSubtotal: true,
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 12),
                            // Total
                            _buildPrecioRow(
                              'Total',
                              '\$${precioTotal.toStringAsFixed(2)}',
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Fecha esperada
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: AppColors.borderGrey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: InkWell(
                        onTap: _selectFechaEsperada,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryNew.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.calendar_today,
                                  color: AppColors.primaryNew,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Fecha esperada',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _fechaEsperada != null
                                          ? DateFormat('EEEE, d MMMM yyyy', 'es')
                                              .format(_fechaEsperada!)
                                          : 'Selecciona una fecha',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryNewDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: AppColors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Notas (opcional)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: AppColors.borderGrey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Notas para el lavador (opcional)',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _notasController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText:
                                    'Ej: El vehículo está en el estacionamiento...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.borderGrey.withOpacity(0.5),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.borderGrey.withOpacity(0.5),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.primaryNew,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // Space for button
                ],
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isCreatingOrder ? null : _confirmarOrden,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNew,
              disabledBackgroundColor: AppColors.grey,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _isCreatingOrder
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Confirmar Orden',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrecioRow(String label, String precio,
      {bool isSubtotal = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? AppColors.primaryNewDark : AppColors.grey,
            ),
          ),
        ),
        Text(
          precio,
          style: TextStyle(
            fontSize: isTotal ? 20 : 15,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: isTotal ? AppColors.primaryNew : AppColors.primaryNewDark,
          ),
        ),
      ],
    );
  }
}
