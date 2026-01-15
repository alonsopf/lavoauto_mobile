import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/servicios_repository.dart';
import '../../utils/utils.dart';
import 'servicios_event.dart';
import 'servicios_state.dart';

@injectable
class ServiciosBloc extends Bloc<ServiciosEvent, ServiciosState> {
  final ServiciosRepository serviciosRepository;

  ServiciosBloc(this.serviciosRepository)
      : super(const ServiciosInitial()) {
    on<LoadServiciosEvent>(_onLoadServicios);
    on<LoadCatalogoEvent>(_onLoadCatalogo);
    on<AddServicioPrecioEvent>(_onAddServicioPrecio);
    on<DeleteServicioPrecioEvent>(_onDeleteServicioPrecio);
    on<UpdateServicioDisponibilidadEvent>(_onUpdateDisponibilidad);
    on<ResetServiciosEvent>(_onResetServicios);
  }

  Future<void> _onLoadServicios(
      LoadServiciosEvent event, Emitter<ServiciosState> emit) async {
    emit(const ServiciosLoading());

    try {
      final token = Utils.getAuthenticationToken();
      if (token.isEmpty) {
        emit(const ServiciosError('No authentication token found'));
        return;
      }

      final response = await serviciosRepository.getLavadorServicios(token);

      if (response.data != null) {
        emit(ServiciosLoaded(response.data!));
      } else {
        emit(ServiciosError(response.errorMessage ?? 'Failed to load servicios'));
      }
    } catch (e) {
      emit(ServiciosError('Error loading servicios: $e'));
    }
  }

  Future<void> _onLoadCatalogo(
      LoadCatalogoEvent event, Emitter<ServiciosState> emit) async {
    emit(const ServiciosLoading());

    try {
      final response = await serviciosRepository.getTiposServicioCatalogo();

      if (response.data != null) {
        emit(CatalogoLoaded(response.data!));
      } else {
        emit(ServiciosError(response.errorMessage ?? 'Failed to load catalog'));
      }
    } catch (e) {
      emit(ServiciosError('Error loading catalog: $e'));
    }
  }

  Future<void> _onAddServicioPrecio(
      AddServicioPrecioEvent event, Emitter<ServiciosState> emit) async {
    emit(const ServicioSaving());

    try {
      final token = Utils.getAuthenticationToken();
      if (token.isEmpty) {
        emit(const ServiciosError('No authentication token found'));
        return;
      }

      final response = await serviciosRepository.addOrUpdateServicio(
        token: token,
        tipoServicioId: event.tipoServicioId,
        categoriaVehiculo: event.categoriaVehiculo,
        precio: event.precio,
        duracionEstimada: event.duracionEstimada,
        disponible: event.disponible,
      );

      if (response.data != null) {
        emit(const ServicioSaved('Servicio guardado exitosamente'));
        // Reload servicios after saving
        add(const LoadServiciosEvent());
      } else {
        emit(ServiciosError(response.errorMessage ?? 'Failed to save servicio'));
      }
    } catch (e) {
      emit(ServiciosError('Error saving servicio: $e'));
    }
  }

  Future<void> _onDeleteServicioPrecio(
      DeleteServicioPrecioEvent event, Emitter<ServiciosState> emit) async {
    emit(const ServicioSaving());

    try {
      final token = Utils.getAuthenticationToken();
      if (token.isEmpty) {
        emit(const ServiciosError('No authentication token found'));
        return;
      }

      final response = await serviciosRepository.deleteServicio(
        token: token,
        precioId: event.precioId,
      );

      if (response.data == true) {
        emit(const ServicioDeleted('Servicio eliminado exitosamente'));
        // Reload servicios after deleting
        add(const LoadServiciosEvent());
      } else {
        emit(ServiciosError(response.errorMessage ?? 'Failed to delete servicio'));
      }
    } catch (e) {
      emit(ServiciosError('Error deleting servicio: $e'));
    }
  }

  Future<void> _onUpdateDisponibilidad(UpdateServicioDisponibilidadEvent event,
      Emitter<ServiciosState> emit) async {
    try {
      final token = Utils.getAuthenticationToken();
      if (token.isEmpty) {
        emit(const ServiciosError('No authentication token found'));
        return;
      }

      final response = await serviciosRepository.updateServicioDisponibilidad(
        token: token,
        precioId: event.precioId,
        disponible: event.disponible,
      );

      if (response.data == true) {
        emit(ServicioDisponibilidadUpdated(
            'Disponibilidad actualizada a ${event.disponible ? "disponible" : "no disponible"}'));
        // Reload servicios after updating
        add(const LoadServiciosEvent());
      } else {
        emit(ServiciosError(
            response.errorMessage ?? 'Failed to update disponibilidad'));
      }
    } catch (e) {
      emit(ServiciosError('Error updating disponibilidad: $e'));
    }
  }

  Future<void> _onResetServicios(
      ResetServiciosEvent event, Emitter<ServiciosState> emit) async {
    emit(const ServiciosInitial());
  }
}
