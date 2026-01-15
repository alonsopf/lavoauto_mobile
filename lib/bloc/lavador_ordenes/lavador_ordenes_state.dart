import 'package:equatable/equatable.dart';
import '../../data/models/orden_model.dart';

abstract class LavadorOrdenesState extends Equatable {
  const LavadorOrdenesState();

  @override
  List<Object?> get props => [];
}

class LavadorOrdenesInitial extends LavadorOrdenesState {
  const LavadorOrdenesInitial();
}

class LavadorOrdenesLoading extends LavadorOrdenesState {
  const LavadorOrdenesLoading();
}

class OrdenesPendientesLoaded extends LavadorOrdenesState {
  final List<OrdenModel> ordenes;

  const OrdenesPendientesLoaded(this.ordenes);

  @override
  List<Object?> get props => [ordenes];
}

class OrdenesActivasLoaded extends LavadorOrdenesState {
  final List<OrdenModel> ordenes;

  const OrdenesActivasLoaded(this.ordenes);

  @override
  List<Object?> get props => [ordenes];
}

class ServicioIniciado extends LavadorOrdenesState {
  final String message;

  const ServicioIniciado(this.message);

  @override
  List<Object?> get props => [message];
}

class ServicioCompletado extends LavadorOrdenesState {
  final String message;

  const ServicioCompletado(this.message);

  @override
  List<Object?> get props => [message];
}

class LavadorOrdenesError extends LavadorOrdenesState {
  final String message;

  const LavadorOrdenesError(this.message);

  @override
  List<Object?> get props => [message];
}
