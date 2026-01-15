import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/vehiculos/vehiculos_bloc.dart';
import 'package:lavoauto/bloc/vehiculos/vehiculos_event.dart';
import 'package:lavoauto/bloc/vehiculos/vehiculos_state.dart';
import 'package:lavoauto/data/models/vehiculo_model.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class AgregarVehiculoPage extends StatefulWidget {
  const AgregarVehiculoPage({super.key});

  @override
  State<AgregarVehiculoPage> createState() => _AgregarVehiculoPageState();
}

class _AgregarVehiculoPageState extends State<AgregarVehiculoPage> {
  late VehiculosBloc _vehiculosBloc;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _aliasController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _placasController = TextEditingController();

  VehiculoModel? _selectedVehiculo;

  @override
  void initState() {
    super.initState();
    _vehiculosBloc = context.read<VehiculosBloc>();
    _vehiculosBloc.add(const LoadCatalogoVehiculosEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _aliasController.dispose();
    _colorController.dispose();
    _placasController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (value.length >= 2) {
      _vehiculosBloc.add(LoadCatalogoVehiculosEvent(search: value));
    } else if (value.isEmpty) {
      _vehiculosBloc.add(const LoadCatalogoVehiculosEvent());
    }
  }

  void _onVehiculoSelected(VehiculoModel vehiculo) {
    setState(() {
      _selectedVehiculo = vehiculo;
    });
    // Auto-fill alias with vehicle name
    _aliasController.text = vehiculo.displayName;
  }

  Future<void> _saveVehiculo() async {
    if (_selectedVehiculo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona un vehículo'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final token = Utils.getAuthenticationToken();
    _vehiculosBloc.add(AddClienteVehiculoEvent(
      token: token,
      vehiculoId: _selectedVehiculo!.vehiculoId,
      alias: _aliasController.text.trim().isEmpty ? null : _aliasController.text.trim(),
      color: _colorController.text.trim().isEmpty ? null : _colorController.text.trim(),
      placas: _placasController.text.trim().isEmpty ? null : _placasController.text.trim(),
    ));
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
          "Agregar Vehículo",
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
            print('🔴 ERROR EN AGREGAR VEHICULO: ${state.message}');
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
          } else if (state is VehiculoSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is CatalogoVehiculoAdded) {
            print('✅ Vehículo agregado al catálogo: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            // El catálogo se recarga automáticamente
          }
        },
        builder: (context, state) {
          final isLoading = state is VehiculosLoading || state is VehiculoSaving;
          final vehiculos = state is CatalogoVehiculosLoaded ? state.vehiculos : <VehiculoModel>[];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step 1: Select vehicle from catalog
                const Text(
                  "1. Busca tu vehículo",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryNewDark,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por marca o modelo...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.borderGrey, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.borderGrey, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primaryNew, width: 2),
                    ),
                  ),
                  onChanged: _onSearchChanged,
                ),
                const SizedBox(height: 16),
                if (isLoading && state is! VehiculoSaving)
                  const Center(child: CircularProgressIndicator())
                else if (vehiculos.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Text(
                            _searchController.text.isEmpty
                                ? 'Comienza a escribir para buscar'
                                : 'No se encontraron resultados',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.grey,
                            ),
                          ),
                          if (_searchController.text.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryNew,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text(
                                'Agregar vehículo',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: () => _mostrarDialogoAgregarVehiculo(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    constraints: const BoxConstraints(maxHeight: 300),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderGrey, width: 1),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: vehiculos.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final vehiculo = vehiculos[index];
                        final isSelected = _selectedVehiculo?.vehiculoId == vehiculo.vehiculoId;

                        return ListTile(
                          selected: isSelected,
                          selectedTileColor: AppColors.primaryNew.withOpacity(0.1),
                          title: Text(
                            vehiculo.displayName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected ? AppColors.primaryNew : AppColors.black,
                            ),
                          ),
                          subtitle: Text(
                            _getTipoVehiculoLabel(vehiculo.tipoVehiculo),
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected ? AppColors.primaryNew : AppColors.grey,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: AppColors.primaryNew)
                              : null,
                          onTap: () => _onVehiculoSelected(vehiculo),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 30),
                // Step 2: Add details
                if (_selectedVehiculo != null) ...[
                  const Text(
                    "2. Detalles del vehículo (opcional)",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryNewDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: "Alias",
                    controller: _aliasController,
                    hint: "Ej: Mi carro, Carro de trabajo",
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: "Color",
                    controller: _colorController,
                    hint: "Ej: Blanco, Negro, Rojo",
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: "Placas",
                    controller: _placasController,
                    hint: "Ej: ABC-123-D",
                  ),
                  const SizedBox(height: 30),
                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNew,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: (isLoading && state is VehiculoSaving) ? null : _saveVehiculo,
                      child: (isLoading && state is VehiculoSaving)
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              "Agregar Vehículo",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderGrey, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderGrey, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryNew, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
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

  void _mostrarDialogoAgregarVehiculo() {
    final marcaController = TextEditingController();
    final modeloController = TextEditingController();
    String? categoriaSeleccionada;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Agregar Vehículo al Catálogo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: marcaController,
                  decoration: InputDecoration(
                    labelText: 'Marca',
                    hintText: 'Ej: Toyota, Honda, Ford',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: modeloController,
                  decoration: InputDecoration(
                    labelText: 'Modelo',
                    hintText: 'Ej: Corolla, Civic, Mustang',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: categoriaSeleccionada,
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'moto', child: Text('Motocicleta')),
                    DropdownMenuItem(value: 'compacto', child: Text('Compacto')),
                    DropdownMenuItem(value: 'sedan', child: Text('Sedán')),
                    DropdownMenuItem(value: 'suv', child: Text('SUV')),
                    DropdownMenuItem(value: 'pickup', child: Text('Pickup')),
                    DropdownMenuItem(value: 'camioneta_grande', child: Text('Camioneta Grande')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      categoriaSeleccionada = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNew,
              ),
              onPressed: () {
                if (marcaController.text.trim().isEmpty ||
                    modeloController.text.trim().isEmpty ||
                    categoriaSeleccionada == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor completa todos los campos'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }

                // Cerrar diálogo
                Navigator.pop(dialogContext);

                // Agregar al catálogo
                _vehiculosBloc.add(AddCatalogoVehiculoEvent(
                  marca: marcaController.text.trim(),
                  modelo: modeloController.text.trim(),
                  categoria: categoriaSeleccionada!,
                ));
              },
              child: const Text('Agregar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
