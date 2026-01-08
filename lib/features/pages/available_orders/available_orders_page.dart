import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/lavador/available_order_detail_bloc.dart';
import 'package:lavoauto/bloc/worker/jobsearch/jobsearch_bloc.dart';
import 'package:lavoauto/data/models/request/worker/availableOrdersRequest_modal.dart';
import 'package:lavoauto/data/models/response/worker/orders_response_modal.dart';
import 'package:lavoauto/dependencyInjection/di.dart';
import 'package:lavoauto/features/pages/order_bid/order_bid_page.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class AvailableOrdersPage extends StatefulWidget {
  const AvailableOrdersPage({super.key});

  @override
  State<AvailableOrdersPage> createState() => _AvailableOrdersPageState();
}

class _AvailableOrdersPageState extends State<AvailableOrdersPage> {
  @override
  void initState() {
    super.initState();
    String token = Utils.getAuthenticationToken() ?? '';
    context.read<JobsearchBloc>().add(
          FetchAvailableOrdersEvent(ListAvailableOrdersRequest(token: token)),
        );
  }

  String _getServiceType(WorkerOrder order) {
    // Inferir el tipo de servicio basado en metodoSecado
    if (order.metodoSecado != null && order.metodoSecado!.toLowerCase().contains('plancha')) {
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

  String _getZone(WorkerOrder order) {
    // TODO: Calculate zone based on lat/lon or use address
    if (order.direccion != null && order.direccion!.isNotEmpty) {
      // Simple logic to extract zone from address
      if (order.direccion!.toLowerCase().contains('centro')) return "Zona Centro";
      if (order.direccion!.toLowerCase().contains('norte')) return "Zona Norte";
      if (order.direccion!.toLowerCase().contains('sur')) return "Zona Sur";
      if (order.direccion!.toLowerCase().contains('este')) return "Zona Este";
      if (order.direccion!.toLowerCase().contains('oeste')) return "Zona Oeste";
    }
    return "Zona Centro";
  }

  String _getTime(String? fechaProgramada) {
    if (fechaProgramada == null || fechaProgramada.isEmpty) return "Por definir";
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
    if (fechaProgramada == null || fechaProgramada.isEmpty) return "Por definir";
    try {
      final date = DateTime.parse(fechaProgramada);
      final months = [
        'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
      ];
      return "${date.day} ${months[date.month - 1]}, ${_getTime(fechaProgramada)}";
    } catch (e) {
      return "Por definir";
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
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Órdenes disponibles",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<JobsearchBloc, JobsearchState>(
          builder: (context, state) {
            if (state is JobsearchLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryNew),
                ),
              );
            } else if (state is JobsearchSuccess) {
              if (state.workerOrdersResponse.orders?.isEmpty == true) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.work_outline,
                          size: 80,
                          color: AppColors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Por el momento, no hay\ntrabajos disponibles",
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
              return _buildOrdersList(context, state.workerOrdersResponse.orders ?? []);
            } else if (state is JobsearchFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    state.errorMessage,
                    style: const TextStyle(
                      fontSize: 18.0,
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
                "Cargando órdenes...",
                style: TextStyle(
                  fontSize: 20.0,
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

  Widget _buildOrdersList(BuildContext context, List<WorkerOrder> orders) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(context, order);
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, WorkerOrder order) {
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
          // Ver pedido button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNew,
                elevation: 0,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<AvailableOrderDetailBloc>(
                      create: (context) => AppContainer.getIt.get<AvailableOrderDetailBloc>(),
                      child: OrderBidPage(orderId: order.ordenId),
                    ),
                  ),
                );
              },
              child: const Text(
                "Ver pedido",
                style: TextStyle(
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

