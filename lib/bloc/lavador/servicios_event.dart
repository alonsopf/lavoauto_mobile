import 'package:equatable/equatable.dart';

abstract class ServiciosEvent extends Equatable {
  const ServiciosEvent();

  @override
  List<Object?> get props => [];
}

class LoadServiciosEvent extends ServiciosEvent {
  const LoadServiciosEvent();
}

class LoadCatalogoEvent extends ServiciosEvent {
  const LoadCatalogoEvent();
}

class AddServicioPrecioEvent extends ServiciosEvent {
  final int tipoServicioId;
  final String categoriaVehiculo;
  final double precio;
  final int duracionEstimada;
  final bool disponible;

  const AddServicioPrecioEvent({
    required this.tipoServicioId,
    required this.categoriaVehiculo,
    required this.precio,
    required this.duracionEstimada,
    this.disponible = true,
  });

  @override
  List<Object?> get props =>
      [tipoServicioId, categoriaVehiculo, precio, duracionEstimada, disponible];
}

class DeleteServicioPrecioEvent extends ServiciosEvent {
  final int precioId;

  const DeleteServicioPrecioEvent(this.precioId);

  @override
  List<Object?> get props => [precioId];
}

class UpdateServicioDisponibilidadEvent extends ServiciosEvent {
  final int precioId;
  final bool disponible;

  const UpdateServicioDisponibilidadEvent({
    required this.precioId,
    required this.disponible,
  });

  @override
  List<Object?> get props => [precioId, disponible];
}

class ResetServiciosEvent extends ServiciosEvent {
  const ResetServiciosEvent();
}
