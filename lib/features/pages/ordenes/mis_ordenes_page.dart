import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lavoauto/bloc/ordenes/ordenes_bloc.dart';
import 'package:lavoauto/bloc/ordenes/ordenes_event.dart';
import 'package:lavoauto/bloc/ordenes/ordenes_state.dart';
import 'package:lavoauto/data/models/orden_model.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class MisOrdenesPage extends StatefulWidget {
  const MisOrdenesPage({super.key});

  @override
  State<MisOrdenesPage> createState() => _MisOrdenesPageState();
}

class _MisOrdenesPageState extends State<MisOrdenesPage>
    with SingleTickerProviderStateMixin {
  late OrdenesBloc _ordenesBloc;
  late TabController _tabController;

  final List<String> _tabs = ['Todas', 'Activas', 'Completadas'];
  final List<String?> _statusFilters = [null, 'pending,in_progress', 'completed'];

  @override
  void initState() {
    super.initState();
    _ordenesBloc = context.read<OrdenesBloc>();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadOrdenes();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      _loadOrdenes();
    }
  }

  void _loadOrdenes() {
    final token = Utils.getAuthenticationToken();
    final statusFilter = _statusFilters[_tabController.index];

    if (token.isNotEmpty) {
      _ordenesBloc.add(LoadMisOrdenesEvent(token, statusFilter: statusFilter));
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryNew,
          labelColor: AppColors.primaryNew,
          unselectedLabelColor: AppColors.grey,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: BlocConsumer<OrdenesBloc, OrdenesState>(
        bloc: _ordenesBloc,
        listener: (context, state) {
          if (state is OrdenesError) {
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
          if (state is OrdenesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MisOrdenesLoaded) {
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
              Icons.assignment_outlined,
              size: 100,
              color: AppColors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'No tienes órdenes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryNewDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Crea tu primera orden para ver el historial aquí',
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
          // TODO: Navigate to order detail
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Detalle de orden próximamente'),
              backgroundColor: AppColors.primaryNew,
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Status badge and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusBadge(orden.status),
                  Text(
                    _formatDate(orden.createdAt),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Lavador info
              if (orden.lavador != null) ...[
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primaryNew.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.primaryNew,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orden.lavador!.nombreCompleto,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryNewDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.amber[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                orden.lavador!.calificacionPromedio
                                    .toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
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
                    Text(
                      orden.vehiculo!.descripcion,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              // Distance and price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
              // Status specific info
              if (orden.status == OrdenStatus.inProgress &&
                  orden.startedAt != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.blue[700],
                      ),
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
}
