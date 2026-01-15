import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/order_flow/order_flow_bloc.dart';
import 'package:lavoauto/bloc/order_flow/order_flow_event.dart';
import 'package:lavoauto/bloc/order_flow/order_flow_state.dart';
import 'package:lavoauto/data/models/lavador_cercano_model.dart';
import 'package:lavoauto/features/pages/order_flow/confirmar_orden_page.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class SeleccionarLavadorPage extends StatefulWidget {
  const SeleccionarLavadorPage({super.key});

  @override
  State<SeleccionarLavadorPage> createState() => _SeleccionarLavadorPageState();
}

class _SeleccionarLavadorPageState extends State<SeleccionarLavadorPage> {
  late OrderFlowBloc _orderFlowBloc;
  String? _vehiculoInfo;

  @override
  void initState() {
    super.initState();
    _orderFlowBloc = context.read<OrderFlowBloc>();
    _loadLavadores();
  }

  void _loadLavadores() {
    final token = Utils.getAuthenticationToken();
    if (token.isNotEmpty) {
      _orderFlowBloc.add(LoadLavadoresCercanosEvent(token));
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
          "Selecciona un Lavador",
          style: TextStyle(
            color: AppColors.primaryNewDark,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
      ),
      body: BlocConsumer<OrderFlowBloc, OrderFlowState>(
        bloc: _orderFlowBloc,
        listener: (context, state) {
          if (state is OrderFlowError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 5),
              ),
            );
          } else if (state is LavadorSelectedForOrder) {
            // TODO: Navigate to next step (service selection or order confirmation)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Lavador seleccionado: ${state.lavadorNombre}\n'
                  'Distancia: ${state.distanciaKm.toStringAsFixed(1)} km\n'
                  'Precio por km: \$${state.precioKm.toStringAsFixed(2)}',
                ),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 3),
              ),
            );
            // For now, just go back
            // Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is OrderFlowLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LavadoresCercanosLoaded) {
            _vehiculoInfo = state.vehiculoInfo;
            return _buildLavadoresList(state.lavadores);
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
              Icons.search_off,
              size: 100,
              color: AppColors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'No hay lavadores disponibles',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryNewDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No encontramos lavadores cercanos a tu ubicación',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _loadLavadores();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNew,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Reintentar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLavadoresList(List<LavadorCercano> lavadores) {
    if (lavadores.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Paso 2 de 2: Selecciona un lavador',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_vehiculoInfo != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.directions_car,
                      size: 18,
                      color: AppColors.primaryNew,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _vehiculoInfo!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryNewDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Text(
                '${lavadores.length} lavador${lavadores.length != 1 ? 'es' : ''} disponible${lavadores.length != 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lavadores.length,
            itemBuilder: (context, index) {
              final lavador = lavadores[index];
              return _buildLavadorCard(lavador, index + 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLavadorCard(LavadorCercano lavador, int position) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: position == 1
              ? AppColors.primaryNew
              : AppColors.borderGrey.withOpacity(0.5),
          width: position == 1 ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Get vehiculo info from state
          final state = _orderFlowBloc.state;
          if (state is LavadoresCercanosLoaded) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConfirmarOrdenPage(
                  lavador: lavador,
                  vehiculoClienteId: state.vehiculoClienteId,
                  vehiculoInfo: state.vehiculoInfo,
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with position badge and name
              Row(
                children: [
                  // Position badge (highlighted for first place)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: position == 1
                          ? AppColors.primaryNew
                          : AppColors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '#$position',
                        style: TextStyle(
                          color: position == 1 ? Colors.white : AppColors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Name and rating
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lavador.nombreCompleto,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryNewDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              lavador.calificacionPromedio.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Arrow icon
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: AppColors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              // Details grid
              Row(
                children: [
                  // Distance
                  Expanded(
                    child: _buildInfoColumn(
                      Icons.location_on,
                      'Distancia',
                      lavador.distanciaFormateada,
                      Colors.blue,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppColors.borderGrey.withOpacity(0.5),
                  ),
                  // Duration
                  Expanded(
                    child: _buildInfoColumn(
                      Icons.access_time,
                      'Tiempo',
                      lavador.duracionFormateada,
                      Colors.orange,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppColors.borderGrey.withOpacity(0.5),
                  ),
                  // Price per km
                  Expanded(
                    child: _buildInfoColumn(
                      Icons.attach_money,
                      'Precio/km',
                      lavador.precioFormateado,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              // Recommended badge for first place
              if (position == 1) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryNew.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.recommend,
                        size: 16,
                        color: AppColors.primaryNew,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Recomendado - Más cercano',
                        style: TextStyle(
                          color: AppColors.primaryNew,
                          fontSize: 14,
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

  Widget _buildInfoColumn(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Column(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 2),
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
}
