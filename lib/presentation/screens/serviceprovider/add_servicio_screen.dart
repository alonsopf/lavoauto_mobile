import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

import '../../../bloc/lavador/servicios_bloc.dart';
import '../../../bloc/lavador/servicios_event.dart';
import '../../../bloc/lavador/servicios_state.dart';
import '../../../data/models/tipo_servicio_model.dart';
import '../../../core/config/injection.dart';
import '../../common_widgets/checklist_info_dialog.dart';

@RoutePage()
class AddServicioScreen extends StatefulWidget {
  final int? tipoServicioId;
  final String? servicioNombre;

  const AddServicioScreen({
    Key? key,
    this.tipoServicioId,
    this.servicioNombre,
  }) : super(key: key);

  @override
  State<AddServicioScreen> createState() => _AddServicioScreenState();
}

class _AddServicioScreenState extends State<AddServicioScreen> {
  late ServiciosBloc _serviciosBloc;
  final _formKey = GlobalKey<FormState>();

  int? _selectedTipoServicioId;
  String? _selectedCategoria;
  final _precioController = TextEditingController();
  final _duracionController = TextEditingController();
  bool _disponible = true;

  List<TipoServicioModel> _catalogoServicios = [];

  final List<Map<String, String>> _categorias = [
    {'id': 'moto', 'label': 'Motocicleta'},
    {'id': 'compacto', 'label': 'Compacto'},
    {'id': 'sedan', 'label': 'Sedán'},
    {'id': 'suv', 'label': 'SUV'},
    {'id': 'pickup', 'label': 'Pickup'},
    {'id': 'camioneta_grande', 'label': 'Camioneta Grande'},
  ];

  @override
  void initState() {
    super.initState();
    _serviciosBloc = getIt<ServiciosBloc>();

    if (widget.tipoServicioId != null) {
      _selectedTipoServicioId = widget.tipoServicioId;
    } else {
      _serviciosBloc.add(const LoadCatalogoEvent());
    }
  }

  @override
  void dispose() {
    _precioController.dispose();
    _duracionController.dispose();
    _serviciosBloc.close();
    super.dispose();
  }

  /// Get the name of the currently selected service
  String? _getSelectedServiceName() {
    if (widget.servicioNombre != null) {
      return widget.servicioNombre;
    }
    if (_selectedTipoServicioId != null && _catalogoServicios.isNotEmpty) {
      final servicio = _catalogoServicios.firstWhere(
        (s) => s.tipoServicioId == _selectedTipoServicioId,
        orElse: () => _catalogoServicios.first,
      );
      return servicio.nombre;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.servicioNombre != null
              ? 'Agregar precio - ${widget.servicioNombre}'
              : 'Agregar Servicio',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: BlocConsumer<ServiciosBloc, ServiciosState>(
        bloc: _serviciosBloc,
        listener: (context, state) {
          if (state is CatalogoLoaded) {
            setState(() {
              _catalogoServicios = state.catalogo;
            });
          } else if (state is ServicioSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            Navigator.pop(context, true);
          } else if (state is ServiciosError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ServicioSaving || state is ServiciosLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Checklist info card - updates based on selected service
                  ChecklistInfoDialog.infoCard(
                    context,
                    tipoServicioId: _selectedTipoServicioId ?? widget.tipoServicioId,
                    nombreServicio: _getSelectedServiceName(),
                  ),
                  const SizedBox(height: 8),
                  if (widget.tipoServicioId == null) ...[
                    const Text(
                      'Tipo de Servicio',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: _selectedTipoServicioId,
                      decoration: InputDecoration(
                        hintText: 'Selecciona un servicio',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      items: _catalogoServicios
                          .map((servicio) => DropdownMenuItem<int>(
                                value: servicio.tipoServicioId,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(servicio.nombre,
                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                    if (servicio.descripcion != null)
                                      Text(
                                        servicio.descripcion!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() {
                                _selectedTipoServicioId = value;
                              });
                            },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecciona un tipo de servicio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                  const Text(
                    'Categoría de Vehículo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCategoria,
                    decoration: InputDecoration(
                      hintText: 'Selecciona una categoría',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    items: _categorias
                        .map((cat) => DropdownMenuItem<String>(
                              value: cat['id'],
                              child: Text(cat['label']!),
                            ))
                        .toList(),
                    onChanged: isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _selectedCategoria = value;
                            });
                          },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Selecciona una categoría';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Precio (MXN)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _precioController,
                    enabled: !isLoading,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Ej: 150.00',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa el precio';
                      }
                      final precio = double.tryParse(value);
                      if (precio == null || precio <= 0) {
                        return 'Ingresa un precio válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Duración Estimada (minutos)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _duracionController,
                    enabled: !isLoading,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: 'Ej: 30',
                      suffixText: 'min',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa la duración';
                      }
                      final duracion = int.tryParse(value);
                      if (duracion == null || duracion <= 0) {
                        return 'Ingresa una duración válida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SwitchListTile(
                    value: _disponible,
                    onChanged: isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _disponible = value;
                            });
                          },
                    title: const Text('Disponible'),
                    subtitle: Text(_disponible
                        ? 'Los clientes pueden solicitar este servicio'
                        : 'Este servicio no estará visible para los clientes'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: isLoading ? null : _saveServicio,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Guardar Servicio',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveServicio() {
    if (_formKey.currentState!.validate()) {
      final tipoServicioId = _selectedTipoServicioId ?? widget.tipoServicioId;
      if (tipoServicioId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: No se ha seleccionado un tipo de servicio'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      _serviciosBloc.add(AddServicioPrecioEvent(
        tipoServicioId: tipoServicioId,
        categoriaVehiculo: _selectedCategoria!,
        precio: double.parse(_precioController.text),
        duracionEstimada: int.parse(_duracionController.text),
        disponible: _disponible,
      ));
    }
  }
}
