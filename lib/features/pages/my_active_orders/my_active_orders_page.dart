import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/worker/services/services_bloc.dart';
import 'package:lavoauto/data/models/request/worker/my_work_request_modal.dart';
import 'package:lavoauto/data/models/response/worker/my_work_response_modal.dart';
import 'package:lavoauto/features/pages/order_tracking/order_tracking_page.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class MyActiveOrdersPage extends StatefulWidget {
  const MyActiveOrdersPage({super.key});

  @override
  State<MyActiveOrdersPage> createState() => _MyActiveOrdersPageState();
}

class _MyActiveOrdersPageState extends State<MyActiveOrdersPage> {
  @override
  void initState() {
    super.initState();
    final token = Utils.getAuthenticationToken();
    context
        .read<ServicesBloc>()
        .add(FetchMyWorkEvent(MyWorkRequest(token: token)));
  }

  String _getServiceType(MyWorkOrder order) {
    if (order.metodoSecado?.toLowerCase().contains('plancha') == true) {
      return "Lavado, secado y planchado";
    } else if (order.metodoSecado != null && order.metodoSecado!.isNotEmpty) {
      return "Lavado y secado";
    }
    return "Lavado";
  }

  String _getLoadSize(double? kg) {
    if (kg == null) return "Carga mediana";
    if (kg < 5) return "Carga pequeña";
    if (kg > 10) return "Carga grande";
    return "Carga mediana";
  }

  String _getZone(MyWorkOrder order) {
    if (order.direccion != null && order.direccion!.isNotEmpty) {
      if (order.direccion!.toLowerCase().contains('centro'))
        return "Zona Centro";
      if (order.direccion!.toLowerCase().contains('norte')) return "Zona Norte";
      if (order.direccion!.toLowerCase().contains('sur')) return "Zona Sur";
      if (order.direccion!.toLowerCase().contains('este')) return "Zona Este";
      if (order.direccion!.toLowerCase().contains('oeste')) return "Zona Oeste";
    }
    return "Zona Centro";
  }

  String _getTime(String? fechaProgramada) {
    if (fechaProgramada == null || fechaProgramada.isEmpty)
      return "Por definir";
    try {
      final date = DateTime.parse(fechaProgramada);
      final hour = date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'p.m.' : 'a.m.';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return "$displayHour:$minute $period";
    } catch (e) {
      return "Por definir";
    }
  }

  String _getFullDate(String? fechaProgramada) {
    if (fechaProgramada == null || fechaProgramada.isEmpty)
      return "Por definir";
    try {
      final date = DateTime.parse(fechaProgramada);
      final months = [
        'Ene',
        'Feb',
        'Mar',
        'Abr',
        'May',
        'Jun',
        'Jul',
        'Ago',
        'Sep',
        'Oct',
        'Nov',
        'Dic'
      ];
      return "${date.day} ${months[date.month - 1]}, ${_getTime(fechaProgramada)}";
    } catch (e) {
      return "Por definir";
    }
  }

  String _translateStatus(String status) {
    switch (status.toLowerCase()) {
      case 'puja_accepted':
      case 'oferta_aceptada':
        return 'Confirmado';
      case 'pendiente':
      case 'pending':
        return 'Pendiente';
      case 'en_progreso':
      case 'in_progress':
      case 'laundry_in_progress':
        return 'En lavado';
      case 'completado':
      case 'completed':
        return 'Completado';
      case 'cancelado':
      case 'cancelled':
        return 'Cancelado';
      case 'en_camino':
      case 'en_camino_entrega':
        return 'En camino';
      case 'recogido':
      case 'recogida':
        return 'Recogido';
      case 'lavando':
        return 'Lavando';
      case 'listo_para_entregar':
        return 'Listo para entregar';
      case 'entregado':
        return 'Entregado';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'puja_accepted':
      case 'oferta_aceptada':
      case 'confirmado':
        return Colors.blue;
      case 'en_progreso':
      case 'in_progress':
      case 'laundry_in_progress':
      case 'lavando':
        return Colors.orange;
      case 'completado':
      case 'completed':
      case 'entregado':
        return Colors.green;
      case 'cancelado':
      case 'cancelled':
        return Colors.red;
      case 'en_camino':
      case 'en_camino_entrega':
      case 'recogido':
      case 'recogida':
        return Colors.purple;
      default:
        return AppColors.primaryNew;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: false,
        backgroundColor: AppColors.primaryNewDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Mis pedidos activos",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ServicesBloc, ServicesState>(
          builder: (context, state) {
            if (state is ServicesLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primaryNew),
                ),
              );
            } else if (state is MyWorkSuccess) {
              final orders = state.myWorkResponse.workOrders ?? [];
              if (orders.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 80,
                          color: AppColors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "No tienes pedidos activos",
                          style: TextStyle(
                            fontSize: 22.0,
                            color: AppColors.primaryNewDark,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return _buildOrdersList(context, orders);
            } else if (state is ServicesFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    state.errorMessage,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return const Center(
              child: Text(
                "Cargando pedidos...",
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.primaryNewDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, List<MyWorkOrder> orders) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(context, order);
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, MyWorkOrder order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Order ID y Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pedido #${order.ordenId}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black.withOpacity(0.6),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.estatus).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getStatusColor(order.estatus),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  _translateStatus(order.estatus),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(order.estatus),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Service type
          Text(
            _getServiceType(order),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 16),
          // Información detallada
          _buildInfoRow(
              Icons.scale_outlined,
              "Peso aproximado",
              order.pesoAproximadoKg != null
                  ? "${order.pesoAproximadoKg!.toStringAsFixed(1)} kg"
                  : "No especificado"),
          const SizedBox(height: 10),
          _buildInfoRow(
              Icons.attach_money,
              "Precio acordado",
              order.precioPorKg != null
                  ? "\$${order.precioPorKg!.toStringAsFixed(2)} MXN/kg"
                  : "No especificado"),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.calendar_today_outlined, "Fecha programada",
              _getFullDate(order.fechaProgramada)),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.location_on_outlined, "Dirección",
              order.direccion ?? "No especificada"),
          if (order.tipoDetergente != null &&
              order.tipoDetergente!.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildInfoRow(Icons.cleaning_services_outlined, "Detergente",
                order.tipoDetergente!),
          ],
          if (order.instruccionesEspeciales != null &&
              order.instruccionesEspeciales!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.note_outlined,
                  size: 20,
                  color: AppColors.primaryNew,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Instrucciones especiales:",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.instruccionesEspeciales!,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          // Seguimiento de pedido button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: order.estatus.toLowerCase() == 'completed' ||
                        order.estatus.toLowerCase() == 'entregado'
                    ? Colors.grey
                    : AppColors.primaryNew,
                elevation: 0,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: order.estatus.toLowerCase() == 'completed' ||
                      order.estatus.toLowerCase() == 'entregado'
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Este pedido ya está completado'),
                          backgroundColor: AppColors.primaryNew,
                        ),
                      );
                    }
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderTrackingPage(order: order),
                        ),
                      );
                    },
              child: Text(
                order.estatus.toLowerCase() == 'completed' ||
                        order.estatus.toLowerCase() == 'entregado'
                    ? "Pedido completado"
                    : "Seguimiento de pedido",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primaryNew,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: AppColors.black.withOpacity(0.7),
              ),
              children: [
                TextSpan(
                  text: "$label: ",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
