import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/vehiculos/vehiculos_bloc.dart';
import 'package:lavoauto/bloc/vehiculos/vehiculos_event.dart';
import 'package:lavoauto/bloc/vehiculos/vehiculos_state.dart';
import 'package:lavoauto/data/models/vehiculo_model.dart';
import 'package:lavoauto/features/pages/vehiculos/agregar_vehiculo_page.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class MisVehiculosPage extends StatefulWidget {
  const MisVehiculosPage({super.key});

  @override
  State<MisVehiculosPage> createState() => _MisVehiculosPageState();
}

class _MisVehiculosPageState extends State<MisVehiculosPage> {
  late VehiculosBloc _vehiculosBloc;

  @override
  void initState() {
    super.initState();
    _vehiculosBloc = context.read<VehiculosBloc>();
    _loadVehiculos();
  }

  void _loadVehiculos() {
    final token = Utils.getAuthenticationToken();
    if (token.isNotEmpty) {
      _vehiculosBloc.add(LoadClienteVehiculosEvent(token));
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
          "Mis Vehículos",
          style: TextStyle(
            color: AppColors.primaryNewDark,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
      ),
      body: BlocConsumer<VehiculosBloc, VehiculosState>(
        bloc: _vehiculosBloc,
        listener: (context, state) {
          if (state is VehiculosError) {
            print('🔴 ERROR EN MIS VEHICULOS: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 8),
                action: SnackBarAction(
                  label: 'Ver',
                  textColor: Colors.white,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error Detallado'),
                        content: SelectableText(state.message),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cerrar'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          } else if (state is VehiculoDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is VehiculosLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ClienteVehiculosLoaded) {
            return _buildVehiculosList(state.vehiculos);
          }

          return _buildEmptyState();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AgregarVehiculoPage(),
            ),
          );
          if (result == true) {
            _loadVehiculos();
          }
        },
        backgroundColor: AppColors.primaryNew,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Agregar Vehículo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
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
              Icons.directions_car_outlined,
              size: 100,
              color: AppColors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'No tienes vehículos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryNewDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Agrega tu primer vehículo para empezar',
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

  Widget _buildVehiculosList(List<ClienteVehiculoModel> vehiculos) {
    if (vehiculos.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vehiculos.length,
      itemBuilder: (context, index) {
        final vehiculo = vehiculos[index];
        return _buildVehiculoCard(vehiculo);
      },
    );
  }

  Widget _buildVehiculoCard(ClienteVehiculoModel vehiculo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.borderGrey.withOpacity(0.5), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primaryNew.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getVehicleIcon(vehiculo.tipoVehiculo),
            color: AppColors.primaryNew,
            size: 28,
          ),
        ),
        title: Text(
          vehiculo.displayName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              vehiculo.fullDescription,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey,
              ),
            ),
            if (vehiculo.tipoVehiculo.isNotEmpty) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryNew.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getTipoVehiculoLabel(vehiculo.tipoVehiculo),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryNew,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.error),
          onPressed: () => _confirmDelete(vehiculo),
        ),
      ),
    );
  }

  IconData _getVehicleIcon(String tipoVehiculo) {
    switch (tipoVehiculo.toLowerCase()) {
      case 'moto':
        return Icons.two_wheeler;
      case 'compacto':
      case 'sedan':
        return Icons.directions_car;
      case 'suv':
        return Icons.airport_shuttle;
      case 'pickup':
      case 'camioneta_grande':
        return Icons.local_shipping;
      default:
        return Icons.directions_car;
    }
  }

  String _getTipoVehiculoLabel(String tipoVehiculo) {
    switch (tipoVehiculo.toLowerCase()) {
      case 'moto':
        return 'Motocicleta';
      case 'compacto':
        return 'Compacto';
      case 'sedan':
        return 'Sedán';
      case 'suv':
        return 'SUV';
      case 'pickup':
        return 'Pickup';
      case 'camioneta_grande':
        return 'Camioneta Grande';
      default:
        return tipoVehiculo;
    }
  }

  Future<void> _confirmDelete(ClienteVehiculoModel vehiculo) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar vehículo'),
        content: Text('¿Estás seguro que deseas eliminar ${vehiculo.displayName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final token = Utils.getAuthenticationToken();
      _vehiculosBloc.add(DeleteClienteVehiculoEvent(
        token: token,
        vehiculoClienteId: vehiculo.vehiculoClienteId,
      ));
    }
  }
}
