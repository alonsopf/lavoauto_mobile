import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lavoauto/bloc/lavador_ordenes/lavador_ordenes_bloc.dart';
import 'package:lavoauto/bloc/lavador_ordenes/lavador_ordenes_event.dart';
import 'package:lavoauto/bloc/lavador_ordenes/lavador_ordenes_state.dart';
import 'package:lavoauto/data/models/orden_model.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class LavadorOrdenDetallePage extends StatefulWidget {
  final OrdenModel orden;

  const LavadorOrdenDetallePage({
    super.key,
    required this.orden,
  });

  @override
  State<LavadorOrdenDetallePage> createState() =>
      _LavadorOrdenDetallePageState();
}

class _LavadorOrdenDetallePageState extends State<LavadorOrdenDetallePage> {
  late LavadorOrdenesBloc _lavadorOrdenesBloc;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _lavadorOrdenesBloc = context.read<LavadorOrdenesBloc>();
  }

  Future<void> _comenzarServicio() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Comenzar Servicio'),
        content: const Text(
          '¿Estás listo para comenzar este servicio?\n\nEsto notificará al cliente que te diriges a su ubicación.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNew,
            ),
            child: const Text(
              'Comenzar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isProcessing = true;
      });

      final token = Utils.getAuthenticationToken();
      _lavadorOrdenesBloc.add(ComenzarServicioEvent(
        token: token,
        ordenId: widget.orden.ordenId,
      ));
    }
  }

  Future<void> _completarServicio() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Completar Servicio'),
        content: const Text(
          '¿Has terminado el servicio?\n\nSe procesará el cobro automáticamente al cliente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text(
              'Completar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isProcessing = true;
      });

      final token = Utils.getAuthenticationToken();
      _lavadorOrdenesBloc.add(CompletarServicioEvent(
        token: token,
        ordenId: widget.orden.ordenId,
      ));
    }
  }

  Future<void> _llamarCliente() async {
    if (widget.orden.cliente?.telefono != null) {
      final uri = Uri.parse('tel:${widget.orden.cliente!.telefono}');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

  Future<void> _abrirMapa() async {
    if (widget.orden.cliente?.direccion != null) {
      final address = Uri.encodeComponent(widget.orden.cliente!.direccion!);
      final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$address');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
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
          "Detalle de Orden",
          style: TextStyle(
            color: AppColors.primaryNewDark,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
      ),
      body: BlocConsumer<LavadorOrdenesBloc, LavadorOrdenesState>(
        bloc: _lavadorOrdenesBloc,
        listener: (context, state) {
          if (state is ServicioIniciado || state is ServicioCompletado) {
            setState(() {
              _isProcessing = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state is ServicioIniciado
                      ? (state as ServicioIniciado).message
                      : (state as ServicioCompletado).message,
                ),
                backgroundColor: AppColors.success,
              ),
            );
            // Go back to orders list
            Navigator.pop(context);
          } else if (state is LavadorOrdenesError) {
            setState(() {
              _isProcessing = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 5),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status banner
                _buildStatusBanner(),
                const SizedBox(height: 16),
                // Cliente info card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildClienteCard(),
                ),
                const SizedBox(height: 16),
                // Vehiculo info card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildVehiculoCard(),
                ),
                const SizedBox(height: 16),
                // Precio desglosado
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildPrecioCard(),
                ),
                const SizedBox(height: 16),
                // Notas
                if (widget.orden.notasCliente != null &&
                    widget.orden.notasCliente!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildNotasCard(),
                  ),
                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildStatusBanner() {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String statusText;

    switch (widget.orden.status) {
      case OrdenStatus.pending:
        backgroundColor = Colors.orange[50]!;
        textColor = Colors.orange[700]!;
        icon = Icons.schedule;
        statusText = 'Orden Pendiente - Esperando que comiences';
        break;
      case OrdenStatus.inProgress:
        backgroundColor = Colors.blue[50]!;
        textColor = Colors.blue[700]!;
        icon = Icons.directions_car;
        statusText = 'Servicio en Progreso';
        break;
      case OrdenStatus.completed:
        backgroundColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
        icon = Icons.check_circle;
        statusText = 'Servicio Completado';
        break;
      case OrdenStatus.cancelled:
        backgroundColor = Colors.red[50]!;
        textColor = Colors.red[700]!;
        icon = Icons.cancel;
        statusText = 'Orden Cancelada';
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: backgroundColor,
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClienteCard() {
    return Card(
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
              'Información del Cliente',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryNewDark,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.blue[700],
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.orden.cliente != null) ...[
                        Text(
                          widget.orden.cliente!.nombreCompleto,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryNewDark,
                          ),
                        ),
                        if (widget.orden.cliente!.telefono != null) ...[
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _llamarCliente,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 16,
                                  color: AppColors.primaryNew,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.orden.cliente!.telefono!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: AppColors.primaryNew,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (widget.orden.cliente?.direccion != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 20,
                    color: Colors.red[400],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dirección',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.orden.cliente!.direccion!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryNewDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _abrirMapa,
                  icon: const Icon(Icons.map),
                  label: const Text('Abrir en Mapa'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryNew,
                    side: const BorderSide(color: AppColors.primaryNew),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
            if (widget.orden.fechaEsperada != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: AppColors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Fecha esperada: ${_formatExpectedDate(widget.orden.fechaEsperada!)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVehiculoCard() {
    if (widget.orden.vehiculo == null) return const SizedBox.shrink();

    return Card(
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
              'Vehículo a Lavar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryNewDark,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getVehiculoCategoryColor(
                      widget.orden.vehiculo!.categoria,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(widget.orden.vehiculo!.categoria),
                    size: 32,
                    color: _getVehiculoCategoryColor(
                      widget.orden.vehiculo!.categoria,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.orden.vehiculo!.descripcion,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryNewDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.orden.vehiculo!.categoria.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: _getVehiculoCategoryColor(
                            widget.orden.vehiculo!.categoria,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.orden.vehiculo!.color != null ||
                widget.orden.vehiculo!.placas != null) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              if (widget.orden.vehiculo!.color != null)
                _buildDetailRow('Color', widget.orden.vehiculo!.color!),
              if (widget.orden.vehiculo!.placas != null) ...[
                const SizedBox(height: 8),
                _buildDetailRow('Placas', widget.orden.vehiculo!.placas!),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPrecioCard() {
    return Card(
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
              'Desglose de Precio',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryNewDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildPrecioRow(
              'Tarifa base',
              widget.orden.precioBaseFormateado,
            ),
            const SizedBox(height: 12),
            _buildPrecioRow(
              'Distancia (${widget.orden.distanciaKm.toStringAsFixed(1)} km × \$${widget.orden.precioKm.toStringAsFixed(2)}/km)',
              widget.orden.precioDistanciaFormateado,
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total a Cobrar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryNewDark,
                  ),
                ),
                Text(
                  widget.orden.precioTotalFormateado,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryNew,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotasCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Colors.amber[200]!,
          width: 1,
        ),
      ),
      color: Colors.amber[50],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.note, color: Colors.amber[700], size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Notas del Cliente',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryNewDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.orden.notasCliente!,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.primaryNewDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    if (widget.orden.status == OrdenStatus.completed ||
        widget.orden.status == OrdenStatus.cancelled) {
      return const SizedBox.shrink();
    }

    return Container(
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
          onPressed: _isProcessing
              ? null
              : (widget.orden.status == OrdenStatus.pending
                  ? _comenzarServicio
                  : _completarServicio),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.orden.status == OrdenStatus.pending
                ? AppColors.primaryNew
                : Colors.green,
            disabledBackgroundColor: AppColors.grey,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: _isProcessing
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.orden.status == OrdenStatus.pending
                          ? Icons.play_arrow
                          : Icons.check_circle,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.orden.status == OrdenStatus.pending
                          ? 'Comenzar Servicio'
                          : 'Ya Terminé',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryNewDark,
          ),
        ),
      ],
    );
  }

  Widget _buildPrecioRow(String label, String precio) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.grey,
            ),
          ),
        ),
        Text(
          precio,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryNewDark,
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'moto':
        return Icons.two_wheeler;
      case 'compacto':
        return Icons.directions_car;
      case 'sedan':
        return Icons.directions_car;
      case 'suv':
        return Icons.airport_shuttle;
      case 'pickup':
        return Icons.local_shipping;
      case 'camionetagrande':
        return Icons.local_shipping;
      default:
        return Icons.directions_car;
    }
  }

  Color _getVehiculoCategoryColor(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'moto':
        return Colors.orange;
      case 'compacto':
        return Colors.blue;
      case 'sedan':
        return Colors.green;
      case 'suv':
        return Colors.purple;
      case 'pickup':
        return Colors.red;
      case 'camionetagrande':
        return Colors.brown;
      default:
        return AppColors.primaryNew;
    }
  }

  String _formatExpectedDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('EEEE, d MMMM yyyy', 'es').format(date);
    } catch (e) {
      return isoDate;
    }
  }
}
