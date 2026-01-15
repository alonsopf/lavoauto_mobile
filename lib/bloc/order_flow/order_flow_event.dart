import 'package:equatable/equatable.dart';

abstract class OrderFlowEvent extends Equatable {
  const OrderFlowEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load client vehicles for vehicle selection (Step 1)
class LoadClienteVehiculosForOrderEvent extends OrderFlowEvent {
  final String token;

  const LoadClienteVehiculosForOrderEvent(this.token);

  @override
  List<Object?> get props => [token];
}

/// Event when user selects a vehicle (Step 1 complete)
class SelectVehiculoEvent extends OrderFlowEvent {
  final int vehiculoClienteId;
  final String vehiculoInfo; // e.g., "Toyota Corolla 2020 (Rojo)"

  const SelectVehiculoEvent({
    required this.vehiculoClienteId,
    required this.vehiculoInfo,
  });

  @override
  List<Object?> get props => [vehiculoClienteId, vehiculoInfo];
}

/// Event to load nearby lavadores (Step 2)
class LoadLavadoresCercanosEvent extends OrderFlowEvent {
  final String token;

  const LoadLavadoresCercanosEvent(this.token);

  @override
  List<Object?> get props => [token];
}

/// Event when user selects a lavador (Step 2 complete)
class SelectLavadorEvent extends OrderFlowEvent {
  final int lavadorId;
  final String lavadorNombre;
  final double distanciaKm;
  final double precioKm;

  const SelectLavadorEvent({
    required this.lavadorId,
    required this.lavadorNombre,
    required this.distanciaKm,
    required this.precioKm,
  });

  @override
  List<Object?> get props => [lavadorId, lavadorNombre, distanciaKm, precioKm];
}

/// Event to reset the order flow
class ResetOrderFlowEvent extends OrderFlowEvent {
  const ResetOrderFlowEvent();
}
