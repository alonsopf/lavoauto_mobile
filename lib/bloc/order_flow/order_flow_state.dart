import 'package:equatable/equatable.dart';

import '../../data/models/lavador_cercano_model.dart';
import '../../data/models/vehiculo_model.dart';

abstract class OrderFlowState extends Equatable {
  const OrderFlowState();

  @override
  List<Object?> get props => [];
}

class OrderFlowInitial extends OrderFlowState {
  const OrderFlowInitial();
}

class OrderFlowLoading extends OrderFlowState {
  const OrderFlowLoading();
}

/// State after client vehicles are loaded (Step 1 ready)
class ClienteVehiculosLoadedForOrder extends OrderFlowState {
  final List<ClienteVehiculoModel> vehiculos;

  const ClienteVehiculosLoadedForOrder(this.vehiculos);

  @override
  List<Object?> get props => [vehiculos];
}

/// State after user selects a vehicle (Step 1 complete, ready for Step 2)
class VehiculoSelectedForOrder extends OrderFlowState {
  final int vehiculoClienteId;
  final String vehiculoInfo;
  final String categoriaVehiculo;

  const VehiculoSelectedForOrder({
    required this.vehiculoClienteId,
    required this.vehiculoInfo,
    required this.categoriaVehiculo,
  });

  @override
  List<Object?> get props => [vehiculoClienteId, vehiculoInfo, categoriaVehiculo];
}

/// State after nearby lavadores are loaded (Step 2 ready)
class LavadoresCercanosLoaded extends OrderFlowState {
  final List<LavadorCercano> lavadores;
  final int vehiculoClienteId;
  final String vehiculoInfo;
  final String categoriaVehiculo;
  final String? clienteDireccion;

  const LavadoresCercanosLoaded({
    required this.lavadores,
    required this.vehiculoClienteId,
    required this.vehiculoInfo,
    required this.categoriaVehiculo,
    this.clienteDireccion,
  });

  @override
  List<Object?> get props => [lavadores, vehiculoClienteId, vehiculoInfo, categoriaVehiculo, clienteDireccion];
}

/// State after user selects a lavador (Step 2 complete, ready to proceed)
class LavadorSelectedForOrder extends OrderFlowState {
  final int vehiculoClienteId;
  final String vehiculoInfo;
  final int lavadorId;
  final String lavadorNombre;
  final double distanciaKm;
  final double precioKm;

  const LavadorSelectedForOrder({
    required this.vehiculoClienteId,
    required this.vehiculoInfo,
    required this.lavadorId,
    required this.lavadorNombre,
    required this.distanciaKm,
    required this.precioKm,
  });

  @override
  List<Object?> get props => [
        vehiculoClienteId,
        vehiculoInfo,
        lavadorId,
        lavadorNombre,
        distanciaKm,
        precioKm,
      ];
}

class OrderFlowError extends OrderFlowState {
  final String message;

  const OrderFlowError(this.message);

  @override
  List<Object?> get props => [message];
}
