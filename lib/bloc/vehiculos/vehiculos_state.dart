import 'package:equatable/equatable.dart';
import '../../data/models/vehiculo_model.dart';

abstract class VehiculosState extends Equatable {
  const VehiculosState();

  @override
  List<Object?> get props => [];
}

class VehiculosInitial extends VehiculosState {
  const VehiculosInitial();
}

class VehiculosLoading extends VehiculosState {
  const VehiculosLoading();
}

class ClienteVehiculosLoaded extends VehiculosState {
  final List<ClienteVehiculoModel> vehiculos;

  const ClienteVehiculosLoaded(this.vehiculos);

  @override
  List<Object?> get props => [vehiculos];
}

class CatalogoVehiculosLoaded extends VehiculosState {
  final List<VehiculoModel> vehiculos;

  const CatalogoVehiculosLoaded(this.vehiculos);

  @override
  List<Object?> get props => [vehiculos];
}

class VehiculoSaving extends VehiculosState {
  const VehiculoSaving();
}

class VehiculoSaved extends VehiculosState {
  final String message;

  const VehiculoSaved(this.message);

  @override
  List<Object?> get props => [message];
}

class VehiculoDeleted extends VehiculosState {
  final String message;

  const VehiculoDeleted(this.message);

  @override
  List<Object?> get props => [message];
}

class CatalogoVehiculoAdded extends VehiculosState {
  final String message;
  final int vehiculoCatalogoId;

  const CatalogoVehiculoAdded(this.message, this.vehiculoCatalogoId);

  @override
  List<Object?> get props => [message, vehiculoCatalogoId];
}

class VehiculosError extends VehiculosState {
  final String message;

  const VehiculosError(this.message);

  @override
  List<Object?> get props => [message];
}
