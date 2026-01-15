import 'package:equatable/equatable.dart';
import '../../data/models/tipo_servicio_model.dart';
import '../../data/models/lavador_servicio_model.dart';

abstract class ServiciosState extends Equatable {
  const ServiciosState();

  @override
  List<Object?> get props => [];
}

class ServiciosInitial extends ServiciosState {
  const ServiciosInitial();
}

class ServiciosLoading extends ServiciosState {
  const ServiciosLoading();
}

class ServiciosLoaded extends ServiciosState {
  final List<LavadorServicioModel> servicios;

  const ServiciosLoaded(this.servicios);

  @override
  List<Object?> get props => [servicios];
}

class CatalogoLoaded extends ServiciosState {
  final List<TipoServicioModel> catalogo;

  const CatalogoLoaded(this.catalogo);

  @override
  List<Object?> get props => [catalogo];
}

class ServicioSaving extends ServiciosState {
  const ServicioSaving();
}

class ServicioSaved extends ServiciosState {
  final String message;

  const ServicioSaved(this.message);

  @override
  List<Object?> get props => [message];
}

class ServicioDeleted extends ServiciosState {
  final String message;

  const ServicioDeleted(this.message);

  @override
  List<Object?> get props => [message];
}

class ServicioDisponibilidadUpdated extends ServiciosState {
  final String message;

  const ServicioDisponibilidadUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

class ServiciosError extends ServiciosState {
  final String message;

  const ServiciosError(this.message);

  @override
  List<Object?> get props => [message];
}
