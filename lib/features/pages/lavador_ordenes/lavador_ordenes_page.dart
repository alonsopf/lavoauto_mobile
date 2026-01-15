import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lavoauto/bloc/lavador_ordenes/lavador_ordenes_bloc.dart';
import 'package:lavoauto/bloc/lavador_ordenes/lavador_ordenes_event.dart';
import 'package:lavoauto/bloc/lavador_ordenes/lavador_ordenes_state.dart';
import 'package:lavoauto/data/models/orden_model.dart';
import 'package:lavoauto/features/pages/lavador_ordenes/lavador_orden_detalle_page.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class LavadorOrdenesPage extends StatefulWidget {
  const LavadorOrdenesPage({super.key});

  @override
  State<LavadorOrdenesPage> createState() => _LavadorOrdenesPageState();
}

class _LavadorOrdenesPageState extends State<LavadorOrdenesPage> {
  late LavadorOrdenesBloc _lavadorOrdenesBloc;

  @override
  void initState() {
    super.initState();
    _lavadorOrdenesBloc = context.read<LavadorOrdenesBloc>();
    _loadOrdenes();
  }

  void _loadOrdenes() {
    final token = Utils.getAuthenticationToken();
    if (token.isNotEmpty) {
      _lavadorOrdenesBloc.add(LoadOrdenesPendientesEvent(token));
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
          "Órdenes Recibidas",
          style: TextStyle(
            color: AppColors.primaryNewDark,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primaryNew),
            onPressed: _loadOrdenes,
          ),
        ],
      ),
      body: BlocConsumer<LavadorOrdenesBloc, LavadorOrdenesState>(
        bloc: _lavadorOrdenesBloc,
        listener: (context, state) {
          if (state is LavadorOrdenesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 5),
              ),
            );
          } else if (state is ServicioIniciado) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LavadorOrdenesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrdenesPendientesLoaded) {
            return _buildOrdenesList(state.ordenes);
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 100,
              color: AppColors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'No tienes órdenes pendientes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryNewDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Las nuevas órdenes aparecerán aquí cuando los clientes soliciten tus servicios',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdenesList(List<OrdenModel> ordenes) {
    if (ordenes.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadOrdenes();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ordenes.length,
        itemBuilder: (context, index) {
          final orden = ordenes[index];
          return _buildOrdenCard(orden);
        },
      ),
    );
  }

  Widget _buildOrdenCard(OrdenModel orden) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.borderGrey.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LavadorOrdenDetallePage(orden: orden),
            ),
          ).then((_) {
            // Reload orders when returning from detail
            _loadOrdenes();
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Date and price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 16,
                        color: AppColors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(orden.createdAt),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryNew.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      orden.precioTotalFormateado,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryNew,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              // Cliente info
              if (orden.cliente != null) ...[
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.blue[700],
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orden.cliente!.nombreCompleto,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryNewDark,
                            ),
                          ),
                          if (orden.cliente!.telefono != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.phone,
                                  size: 14,
                                  color: AppColors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  orden.cliente!.telefono!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              // Direccion
              if (orden.cliente?.direccion != null) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 18,
                      color: Colors.red[400],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        orden.cliente!.direccion!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              // Vehiculo info
              if (orden.vehiculo != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_car,
                        size: 24,
                        color: _getVehiculoCategoryColor(
                          orden.vehiculo!.categoria,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              orden.vehiculo!.descripcion,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryNewDark,
                              ),
                            ),
                            if (orden.vehiculo!.color != null ||
                                orden.vehiculo!.placas != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                [
                                  if (orden.vehiculo!.color != null)
                                    orden.vehiculo!.color,
                                  if (orden.vehiculo!.placas != null)
                                    'Placas: ${orden.vehiculo!.placas}',
                                ].join(' • '),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              // Distance and expected date
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      Icons.social_distance,
                      'Distancia',
                      orden.distanciaFormateada,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (orden.fechaEsperada != null)
                    Expanded(
                      child: _buildInfoChip(
                        Icons.calendar_today,
                        'Esperada',
                        _formatExpectedDate(orden.fechaEsperada!),
                        Colors.orange,
                      ),
                    ),
                ],
              ),
              // Notes if any
              if (orden.notasCliente != null &&
                  orden.notasCliente!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.amber[200]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.note,
                        size: 18,
                        color: Colors.amber[700],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          orden.notasCliente!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.amber[900],
                          ),
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
    );
  }

  Widget _buildInfoChip(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryNewDark,
            ),
          ),
        ],
      ),
    );
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

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 60) {
        return 'Hace ${difference.inMinutes} min';
      } else if (difference.inHours < 24) {
        return 'Hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
      } else if (difference.inDays == 1) {
        return 'Ayer ${DateFormat('HH:mm').format(date)}';
      } else {
        return DateFormat('d MMM HH:mm', 'es').format(date);
      }
    } catch (e) {
      return isoDate;
    }
  }

  String _formatExpectedDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final now = DateTime.now();
      final difference = date.difference(now);

      if (difference.inDays == 0) {
        return 'Hoy';
      } else if (difference.inDays == 1) {
        return 'Mañana';
      } else {
        return DateFormat('d MMM', 'es').format(date);
      }
    } catch (e) {
      return isoDate;
    }
  }
}
