import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lavoauto/bloc/lavador_ordenes/lavador_ordenes_bloc.dart';
import 'package:lavoauto/bloc/lavador_ordenes/lavador_ordenes_event.dart';
import 'package:lavoauto/bloc/lavador_ordenes/lavador_ordenes_state.dart';
import 'package:lavoauto/data/models/orden_model.dart';
import 'package:lavoauto/data/repositories/orden_repository.dart';
import 'package:lavoauto/dependencyInjection/di.dart';
import 'package:lavoauto/features/pages/lavador_ordenes/lavador_orden_detalle_page.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class LavadorOrdenesPage extends StatefulWidget {
  const LavadorOrdenesPage({super.key});

  @override
  State<LavadorOrdenesPage> createState() => _LavadorOrdenesPageState();
}

class _LavadorOrdenesPageState extends State<LavadorOrdenesPage>
    with SingleTickerProviderStateMixin {
  late LavadorOrdenesBloc _lavadorOrdenesBloc;
  late TabController _tabController;

  List<OrdenModel> _pendientes = [];
  List<OrdenModel> _enProceso = [];
  List<OrdenModel> _completadas = [];
  bool _isLoading = false;

  final List<String> _tabs = ['Pendientes', 'En Proceso', 'Completadas'];

  @override
  void initState() {
    super.initState();
    _lavadorOrdenesBloc = context.read<LavadorOrdenesBloc>();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadAllOrdenes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAllOrdenes() async {
    setState(() => _isLoading = true);

    final token = Utils.getAuthenticationToken();
    if (token.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final ordenRepository = AppContainer.getIt.get<OrdenRepository>();

      // Load pending orders (this also updates the bloc for the badge)
      _lavadorOrdenesBloc.add(LoadOrdenesPendientesEvent(token));

      // Load all orders with different statuses
      final pendientesResponse = await ordenRepository.getLavadorOrdenesPendientes(token);
      final enProcesoResponse = await ordenRepository.getLavadorOrdenes(token, statusFilter: 'in_progress');
      final completadasResponse = await ordenRepository.getLavadorOrdenes(token, statusFilter: 'completed');

      setState(() {
        _pendientes = pendientesResponse.data?.ordenes ?? [];
        _enProceso = enProcesoResponse.data?.ordenes ?? [];
        _completadas = completadasResponse.data?.ordenes ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar órdenes: $e'),
            backgroundColor: AppColors.error,
          ),
        );
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
          "Mis Órdenes",
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
            onPressed: _loadAllOrdenes,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryNew,
          labelColor: AppColors.primaryNew,
          unselectedLabelColor: AppColors.grey,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Pendientes'),
                  if (_pendientes.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _pendientes.length.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('En Proceso'),
                  if (_enProceso.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _enProceso.length.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Tab(text: 'Completadas'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOrdenesList(_pendientes, 'pendientes'),
                _buildOrdenesList(_enProceso, 'en_proceso'),
                _buildOrdenesList(_completadas, 'completadas'),
              ],
            ),
    );
  }

  Widget _buildEmptyState(String type) {
    String message;
    IconData icon;

    switch (type) {
      case 'pendientes':
        message = 'No tienes órdenes pendientes';
        icon = Icons.inbox_outlined;
        break;
      case 'en_proceso':
        message = 'No tienes órdenes en proceso';
        icon = Icons.hourglass_empty;
        break;
      case 'completadas':
        message = 'No tienes órdenes completadas';
        icon = Icons.check_circle_outline;
        break;
      default:
        message = 'No hay órdenes';
        icon = Icons.inbox_outlined;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryNewDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdenesList(List<OrdenModel> ordenes, String type) {
    if (ordenes.isEmpty) {
      return _buildEmptyState(type);
    }

    return RefreshIndicator(
      onRefresh: () async {
        await _loadAllOrdenes();
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
            _loadAllOrdenes();
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Status badge and price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusBadge(orden.status),
                  Text(
                    orden.precioTotalFormateado,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryNew,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Cliente info
              if (orden.cliente != null) ...[
                Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.blue[700],
                        size: 24,
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
                          const SizedBox(height: 2),
                          Text(
                            _formatDate(orden.createdAt),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              // Vehiculo info
              if (orden.vehiculo != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.directions_car,
                      size: 18,
                      color: AppColors.grey.withOpacity(0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        orden.vehiculo!.descripcion,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                if (orden.vehiculo!.color != null && orden.vehiculo!.color!.isNotEmpty ||
                    orden.vehiculo!.placas != null && orden.vehiculo!.placas!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      if (orden.vehiculo!.color != null && orden.vehiculo!.color!.isNotEmpty)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.palette,
                              size: 16,
                              color: AppColors.grey.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              orden.vehiculo!.color!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryNewDark,
                              ),
                            ),
                          ],
                        ),
                      if (orden.vehiculo!.placas != null && orden.vehiculo!.placas!.isNotEmpty)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.credit_card,
                              size: 16,
                              color: AppColors.grey.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              orden.vehiculo!.placas!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryNewDark,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
              ],
              // Distance
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 18,
                    color: Colors.blue[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    orden.distanciaFormateada,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
              // Fecha esperada
              if (orden.fechaEsperada != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.schedule, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 6),
                      Text(
                        _formatFechaEsperada(orden.fechaEsperada!),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // Notas del cliente
              if (orden.notasCliente != null && orden.notasCliente!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.note, size: 16, color: Colors.amber[700]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          orden.notasCliente!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.amber[900],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // Status specific info
              if (orden.status == OrdenStatus.inProgress && orden.startedAt != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Iniciado: ${_formatDateTime(orden.startedAt!)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
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
    );
  }

  Widget _buildStatusBadge(OrdenStatus status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case OrdenStatus.pending:
        backgroundColor = Colors.orange[50]!;
        textColor = Colors.orange[700]!;
        icon = Icons.schedule;
        break;
      case OrdenStatus.inProgress:
        backgroundColor = Colors.blue[50]!;
        textColor = Colors.blue[700]!;
        icon = Icons.directions_car;
        break;
      case OrdenStatus.completed:
        backgroundColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
        icon = Icons.check_circle;
        break;
      case OrdenStatus.cancelled:
        backgroundColor = Colors.red[50]!;
        textColor = Colors.red[700]!;
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Hoy ${DateFormat('HH:mm').format(date)}';
      } else if (difference.inDays == 1) {
        return 'Ayer ${DateFormat('HH:mm').format(date)}';
      } else if (difference.inDays < 7) {
        return DateFormat('EEEE HH:mm', 'es').format(date);
      } else {
        return DateFormat('d MMM yyyy', 'es').format(date);
      }
    } catch (e) {
      return isoDate;
    }
  }

  String _formatDateTime(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('d MMM HH:mm', 'es').format(date);
    } catch (e) {
      return isoDate;
    }
  }

  String _formatFechaEsperada(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final dateStr = DateFormat('d MMM', 'es').format(date);
      final timeStr = DateFormat('h:mm a', 'es').format(date);
      return '$dateStr a las $timeStr';
    } catch (e) {
      return isoDate;
    }
  }
}
