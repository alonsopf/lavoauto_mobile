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
  final String? clienteDireccion;

  const ConfirmarOrdenPage({
    super.key,
    required this.lavador,
    required this.vehiculoClienteId,
    required this.vehiculoInfo,
    this.clienteDireccion,
  });

  @override
  State<ConfirmarOrdenPage> createState() => _ConfirmarOrdenPageState();
}

class _ConfirmarOrdenPageState extends State<ConfirmarOrdenPage> {
  final OrdenRepository _ordenRepository = getIt<OrdenRepository>();

  DateTime? _fechaEsperada;
  TimeOfDay? _horaEsperada;
  bool _lavadorOcupado = false;
  bool _isLoadingStatus = true;
  bool _isCreatingOrder = false;
  final _notasController = TextEditingController();

  // Selected service
  int? _selectedServicioIndex;
  double _precioServicio = 0.0;
  String _servicioNombre = '';

  @override
  void initState() {
    super.initState();
    // Set default date to tomorrow at 10:00 AM
    _fechaEsperada = DateTime.now().add(const Duration(days: 1));
    _horaEsperada = const TimeOfDay(hour: 10, minute: 0);
    _checkLavadorStatus();
    // Auto-select first service if available
    _initSelectedService();
  }

  void _initSelectedService() {
    final servicios = widget.lavador.servicios;
    if (servicios != null && servicios.isNotEmpty) {
      _selectedServicioIndex = 0;
      final servicio = servicios[0];
      _servicioNombre = servicio.nombre;
      // Get price for the vehicle category if available
      if (servicio.precios.isNotEmpty) {
        _precioServicio = servicio.precios[0].precio;
      }
    }
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
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _fechaEsperada ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      helpText: 'Selecciona la fecha',
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

    if (pickedDate != null) {
      // Now show time picker
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _horaEsperada ?? const TimeOfDay(hour: 10, minute: 0),
        helpText: 'Selecciona la hora',
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

      if (pickedTime != null) {
        setState(() {
          _fechaEsperada = pickedDate;
          _horaEsperada = pickedTime;
        });
      } else {
        // User selected date but cancelled time, keep the date
        setState(() {
          _fechaEsperada = pickedDate;
        });
      }
    }
  }

  Future<void> _selectHoraEsperada() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _horaEsperada ?? const TimeOfDay(hour: 10, minute: 0),
      helpText: 'Selecciona la hora',
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

    if (pickedTime != null) {
      setState(() {
        _horaEsperada = pickedTime;
      });
    }
  }

  String _formatHora(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _confirmarOrden() async {
    if (_fechaEsperada == null || _horaEsperada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona fecha y hora esperada'),
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

      // Combine date and time
      final fechaHoraEsperada = DateTime(
        _fechaEsperada!.year,
        _fechaEsperada!.month,
        _fechaEsperada!.day,
        _horaEsperada!.hour,
        _horaEsperada!.minute,
      );

      print('🟢 Creando orden con precio_servicio: $_precioServicio');
      print('🟢 Fecha y hora esperada: $fechaHoraEsperada');

      final response = await _ordenRepository.crearOrden(
        token: token,
        lavadorId: widget.lavador.lavadorId,
        vehiculoClienteId: widget.vehiculoClienteId,
        distanciaKm: widget.lavador.distanciaKm,
        precioServicio: _precioServicio,
        notasCliente: _notasController.text.trim().isEmpty
            ? null
            : _notasController.text.trim(),
        fechaEsperada: fechaHoraEsperada,
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

          // Navigate back to home - pop 3 screens (confirmar -> lavador -> vehiculo -> home)
          int popCount = 0;
          Navigator.of(context).popUntil((route) {
            popCount++;
            // Pop 3 screens to get back to home, or stop if we hit the first route
            return popCount > 3 || route.isFirst;
          });
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
    // Round distance to 2 decimals for display and calculation
    final distanciaKmRedondeada = (widget.lavador.distanciaKm * 100).round() / 100;
    final precioDistancia = distanciaKmRedondeada * widget.lavador.precioKm;
    final precioTotal = _precioServicio + precioDistancia;

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
                              child: ClipOval(
                                child: widget.lavador.fotoUrl != null &&
                                        widget.lavador.fotoUrl!.isNotEmpty
                                    ? Image.network(
                                        widget.lavador.fotoUrl!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.person,
                                            size: 50,
                                            color: AppColors.primaryNew,
                                          );
                                        },
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.primaryNew,
                                            ),
                                          );
                                        },
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: AppColors.primaryNew,
                                      ),
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
                  // Route visualization - Point A to Point B
                  _buildRouteCard(),
                  const SizedBox(height: 16),
                  // Service selector
                  _buildServiceSelector(),
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
                            // Servicio
                            _buildPrecioRow(
                              'Servicio: $_servicioNombre',
                              '\$${_precioServicio.toStringAsFixed(2)}',
                              isSubtotal: true,
                            ),
                            const SizedBox(height: 12),
                            // Distancia
                            _buildPrecioRow(
                              'Distancia (${distanciaKmRedondeada.toStringAsFixed(2)} km × \$${widget.lavador.precioKm.toStringAsFixed(2)}/km)',
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
                  // Fecha y hora esperada
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
                              'Fecha y Hora Esperada',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryNewDark,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Date selector
                            InkWell(
                              onTap: _selectFechaEsperada,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.bgColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.borderGrey.withOpacity(0.5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryNew.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.calendar_today,
                                        color: AppColors.primaryNew,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Fecha',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: AppColors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            _fechaEsperada != null
                                                ? DateFormat('EEEE, d MMMM yyyy', 'es')
                                                    .format(_fechaEsperada!)
                                                : 'Selecciona una fecha',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryNewDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: AppColors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Time selector
                            InkWell(
                              onTap: _selectHoraEsperada,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.bgColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.borderGrey.withOpacity(0.5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.access_time,
                                        color: Colors.orange[700],
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Hora',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: AppColors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            _horaEsperada != null
                                                ? _formatHora(_horaEsperada!)
                                                : 'Selecciona una hora',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryNewDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: AppColors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildRouteCard() {
    final clientAddress = widget.clienteDireccion;
    final lavadorAddress = widget.lavador.direccion;

    return Padding(
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
                'Ruta del Servicio',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryNewDark,
                ),
              ),
              const SizedBox(height: 16),
              // Route visualization
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side - route line with icons
                  Column(
                    children: [
                      // Client icon (home - origin)
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primaryNew.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.home,
                          color: AppColors.primaryNew,
                          size: 20,
                        ),
                      ),
                      // Dotted line connecting points
                      Container(
                        width: 2,
                        height: 36,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: CustomPaint(
                          painter: _DottedLinePainter(color: AppColors.grey.withOpacity(0.4)),
                        ),
                      ),
                      // Lavador icon (car wash - destination)
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.local_car_wash,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  // Right side - address details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Client location
                        _buildAddressItem(
                          label: 'Cliente (Tu ubicacion)',
                          address: clientAddress,
                          labelColor: AppColors.primaryNew,
                        ),
                        const SizedBox(height: 20),
                        // Lavador location
                        _buildAddressItem(
                          label: 'Lavador (${widget.lavador.nombreCompleto})',
                          address: lavadorAddress,
                          labelColor: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Distance and time badge
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.route,
                      size: 18,
                      color: AppColors.primaryNew,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.lavador.distanciaFormateada,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryNewDark,
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
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryNewDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressItem({
    required String label,
    required String? address,
    required Color labelColor,
  }) {
    final hasAddress = address != null && address.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: labelColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          hasAddress ? address : 'Direccion pendiente de actualizar',
          style: TextStyle(
            fontSize: 14,
            color: hasAddress ? AppColors.primaryNewDark : AppColors.grey,
            fontWeight: FontWeight.w500,
            fontStyle: hasAddress ? FontStyle.normal : FontStyle.italic,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildServiceSelector() {
    final servicios = widget.lavador.servicios;

    if (servicios == null || servicios.isEmpty) {
      return Padding(
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
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.grey, size: 20),
                const SizedBox(width: 12),
                const Text(
                  'No hay servicios disponibles',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
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
                'Selecciona el Servicio',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryNewDark,
                ),
              ),
              const SizedBox(height: 16),
              ...servicios.asMap().entries.map((entry) {
                final index = entry.key;
                final servicio = entry.value;
                final isSelected = _selectedServicioIndex == index;
                // Get price for first available category (should be filtered by vehicle type)
                final precio = servicio.precios.isNotEmpty ? servicio.precios[0].precio : 0.0;
                final duracion = servicio.precios.isNotEmpty ? servicio.precios[0].duracionEstimada : 0;

                return Padding(
                  padding: EdgeInsets.only(bottom: index < servicios.length - 1 ? 12 : 0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedServicioIndex = index;
                        _servicioNombre = servicio.nombre;
                        _precioServicio = precio;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryNew.withOpacity(0.1)
                            : AppColors.bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryNew
                              : AppColors.borderGrey.withOpacity(0.5),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Radio indicator
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? AppColors.primaryNew : AppColors.grey,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primaryNew,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          // Service info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  servicio.nombre,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.primaryNew
                                        : AppColors.primaryNewDark,
                                  ),
                                ),
                                if (servicio.descripcion != null &&
                                    servicio.descripcion!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    servicio.descripcion!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.grey,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: Colors.orange[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '~${duracion}min',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Price
                          Text(
                            '\$${precio.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? AppColors.primaryNew : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for dotted line
class _DottedLinePainter extends CustomPainter {
  final Color color;

  _DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
