import 'package:equatable/equatable.dart';
import '../../data/models/orden_model.dart';

abstract class OrdenesState extends Equatable {
  const OrdenesState();

  @override
  List<Object?> get props => [];
}

class OrdenesInitial extends OrdenesState {
  const OrdenesInitial();
}

class OrdenesLoading extends OrdenesState {
  const OrdenesLoading();
}

class MisOrdenesLoaded extends OrdenesState {
  final List<OrdenModel> ordenes;
  final String? statusFilter;

  const MisOrdenesLoaded(this.ordenes, {this.statusFilter});

  @override
  List<Object?> get props => [ordenes, statusFilter];
}

class OrdenDetailLoaded extends OrdenesState {
  final OrdenModel orden;

  const OrdenDetailLoaded(this.orden);

  @override
  List<Object?> get props => [orden];
}

class OrdenesError extends OrdenesState {
  final String message;

  const OrdenesError(this.message);

  @override
  List<Object?> get props => [message];
}
