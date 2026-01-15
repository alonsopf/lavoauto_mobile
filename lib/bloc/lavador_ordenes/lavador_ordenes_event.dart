import 'package:equatable/equatable.dart';

abstract class LavadorOrdenesEvent extends Equatable {
  const LavadorOrdenesEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load pending orders for lavador
class LoadOrdenesPendientesEvent extends LavadorOrdenesEvent {
  final String token;

  const LoadOrdenesPendientesEvent(this.token);

  @override
  List<Object?> get props => [token];
}

/// Event to load active (in_progress) orders for lavador
class LoadOrdenesActivasEvent extends LavadorOrdenesEvent {
  final String token;

  const LoadOrdenesActivasEvent(this.token);

  @override
  List<Object?> get props => [token];
}

/// Event to start service (pending -> in_progress)
class ComenzarServicioEvent extends LavadorOrdenesEvent {
  final String token;
  final int ordenId;

  const ComenzarServicioEvent({
    required this.token,
    required this.ordenId,
  });

  @override
  List<Object?> get props => [token, ordenId];
}

/// Event to complete service (in_progress -> completed)
class CompletarServicioEvent extends LavadorOrdenesEvent {
  final String token;
  final int ordenId;

  const CompletarServicioEvent({
    required this.token,
    required this.ordenId,
  });

  @override
  List<Object?> get props => [token, ordenId];
}

/// Event to reset lavador ordenes state
class ResetLavadorOrdenesEvent extends LavadorOrdenesEvent {
  const ResetLavadorOrdenesEvent();
}
