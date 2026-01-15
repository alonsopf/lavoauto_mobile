import 'package:equatable/equatable.dart';

abstract class VehiculosEvent extends Equatable {
  const VehiculosEvent();

  @override
  List<Object?> get props => [];
}

class LoadClienteVehiculosEvent extends VehiculosEvent {
  final String token;

  const LoadClienteVehiculosEvent(this.token);

  @override
  List<Object?> get props => [token];
}

class LoadCatalogoVehiculosEvent extends VehiculosEvent {
  final String? search;

  const LoadCatalogoVehiculosEvent({this.search});

  @override
  List<Object?> get props => [search];
}

class AddClienteVehiculoEvent extends VehiculosEvent {
  final String token;
  final int vehiculoId;
  final String? alias;
  final String? color;
  final String? placas;

  const AddClienteVehiculoEvent({
    required this.token,
    required this.vehiculoId,
    this.alias,
    this.color,
    this.placas,
  });

  @override
  List<Object?> get props => [token, vehiculoId, alias, color, placas];
}

class AddCatalogoVehiculoEvent extends VehiculosEvent {
  final String marca;
  final String modelo;
  final String categoria;

  const AddCatalogoVehiculoEvent({
    required this.marca,
    required this.modelo,
    required this.categoria,
  });

  @override
  List<Object?> get props => [marca, modelo, categoria];
}

class DeleteClienteVehiculoEvent extends VehiculosEvent {
  final String token;
  final int vehiculoClienteId;

  const DeleteClienteVehiculoEvent({
    required this.token,
    required this.vehiculoClienteId,
  });

  @override
  List<Object?> get props => [token, vehiculoClienteId];
}

class ResetVehiculosEvent extends VehiculosEvent {
  const ResetVehiculosEvent();
}
