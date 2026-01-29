import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

import '../../../bloc/lavador/servicios_bloc.dart';
import '../../../bloc/lavador/servicios_event.dart';
import '../../../bloc/lavador/servicios_state.dart';
import '../../../data/models/lavador_servicio_model.dart';
import '../../../core/config/injection.dart';
import '../../router/router.gr.dart';
import '../../common_widgets/checklist_info_dialog.dart';

@RoutePage()
class MisServiciosListScreen extends StatefulWidget {
  const MisServiciosListScreen({Key? key}) : super(key: key);

  @override
  State<MisServiciosListScreen> createState() => _MisServiciosListScreenState();
}

class _MisServiciosListScreenState extends State<MisServiciosListScreen> {
  late ServiciosBloc _serviciosBloc;

  @override
  void initState() {
    super.initState();
    _serviciosBloc = getIt<ServiciosBloc>();
    _serviciosBloc.add(const LoadServiciosEvent());
  }

  @override
  void dispose() {
    _serviciosBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Servicios',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        elevation: 0,
        actions: [
          ChecklistInfoDialog.appBarButton(context),
        ],
      ),
      body: BlocConsumer<ServiciosBloc, ServiciosState>(
        bloc: _serviciosBloc,
        listener: (context, state) {
          if (state is ServiciosError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is ServicioSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is ServicioDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is ServicioDisponibilidadUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          }
        },
        builder: (context, state) {
          if (state is ServiciosLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ServiciosLoaded) {
            if (state.servicios.isEmpty) {
              return _buildEmptyState();
            }
            return _buildServiciosList(state.servicios);
          }
          return _buildEmptyState();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddServicio(),
        icon: const Icon(Icons.add),
        label: const Text('Agregar Servicio'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.build_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No tienes servicios configurados',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega tus servicios y precios',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddServicio(),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Primer Servicio'),
          ),
        ],
      ),
    );
  }

  Widget _buildServiciosList(List<LavadorServicioModel> servicios) {
    // Sort services by number of prices (categories) DESC
    final sortedServicios = List<LavadorServicioModel>.from(servicios);
    sortedServicios.sort((a, b) => b.precios.length.compareTo(a.precios.length));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedServicios.length,
      itemBuilder: (context, index) {
        final servicio = sortedServicios[index];
        return _buildServicioCard(servicio);
      },
    );
  }

  Widget _buildServicioCard(LavadorServicioModel servicio) {
    final numCategorias = servicio.precios.length;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                servicio.nombre,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            if (numCategorias > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade300, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.category, size: 14, color: Colors.green.shade700),
                    const SizedBox(width: 4),
                    Text(
                      '$numCategorias',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        subtitle: Text(servicio.descripcion ?? 'Sin descripción'),
        children: [
          if (servicio.precios.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('No hay precios configurados',
                      style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _navigateToAddPrecio(servicio),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Agregar Precio'),
                  ),
                ],
              ),
            )
          else
            ...servicio.precios.map((precio) => ListTile(
                  leading: Icon(
                    _getVehicleIcon(precio.categoriaVehiculo),
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(_getCategoriaLabel(precio.categoriaVehiculo)),
                  subtitle: Text(
                      '${precio.duracionEstimada} minutos • ${precio.disponible ? "Disponible" : "No disponible"}'),
                  trailing: Text(
                    '\$${precio.precio.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () => _showPrecioOptions(precio),
                )),
        ],
      ),
    );
  }

  IconData _getVehicleIcon(String categoria) {
    switch (categoria) {
      case 'moto':
        return Icons.motorcycle;
      case 'compacto':
        return Icons.directions_car;
      case 'sedan':
        return Icons.directions_car;
      case 'suv':
        return Icons.airport_shuttle;
      case 'pickup':
        return Icons.local_shipping;
      case 'camioneta_grande':
        return Icons.fire_truck;
      default:
        return Icons.directions_car;
    }
  }

  String _getCategoriaLabel(String categoria) {
    switch (categoria) {
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
        return categoria;
    }
  }

  void _showPrecioOptions(precio) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(precio.disponible ? Icons.visibility_off : Icons.visibility),
              title: Text(precio.disponible ? 'Marcar como no disponible' : 'Marcar como disponible'),
              onTap: () {
                Navigator.pop(context);
                _serviciosBloc.add(UpdateServicioDisponibilidadEvent(
                  precioId: precio.precioId,
                  disponible: !precio.disponible,
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Eliminar', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(precio.precioId);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(int precioId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de eliminar este precio?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _serviciosBloc.add(DeleteServicioPrecioEvent(precioId));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToAddServicio() async {
    final result = await context.router.push(AddServicioRoute());
    if (result == true && mounted) {
      // Reload services after adding
      _serviciosBloc.add(const LoadServiciosEvent());
    }
  }

  Future<void> _navigateToAddPrecio(LavadorServicioModel servicio) async {
    final result = await context.router.push(
      AddServicioRoute(
        tipoServicioId: servicio.tipoServicioId,
        servicioNombre: servicio.nombre,
      ),
    );
    if (result == true && mounted) {
      // Reload services after adding
      _serviciosBloc.add(const LoadServiciosEvent());
    }
  }
}
