import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/vehiculos_repository.dart';
import 'vehiculos_event.dart';
import 'vehiculos_state.dart';

@injectable
class VehiculosBloc extends Bloc<VehiculosEvent, VehiculosState> {
  final VehiculosRepository vehiculosRepository;

  VehiculosBloc(this.vehiculosRepository) : super(const VehiculosInitial()) {
    on<LoadClienteVehiculosEvent>(_onLoadClienteVehiculos);
    on<LoadCatalogoVehiculosEvent>(_onLoadCatalogoVehiculos);
    on<AddCatalogoVehiculoEvent>(_onAddCatalogoVehiculo);
    on<AddClienteVehiculoEvent>(_onAddClienteVehiculo);
    on<DeleteClienteVehiculoEvent>(_onDeleteClienteVehiculo);
    on<ResetVehiculosEvent>(_onResetVehiculos);
  }

  Future<void> _onLoadClienteVehiculos(
      LoadClienteVehiculosEvent event, Emitter<VehiculosState> emit) async {
    emit(const VehiculosLoading());

    try {
      final response = await vehiculosRepository.getClienteVehiculos(event.token);

      if (response.data != null) {
        emit(ClienteVehiculosLoaded(response.data!.vehiculos));
      } else {
        emit(VehiculosError(
            response.errorMessage ?? 'Failed to load vehicles'));
      }
    } catch (e) {
      emit(VehiculosError('Error loading vehicles: $e'));
    }
  }

  Future<void> _onLoadCatalogoVehiculos(
      LoadCatalogoVehiculosEvent event, Emitter<VehiculosState> emit) async {
    emit(const VehiculosLoading());

    try {
      final response = await vehiculosRepository.getCatalogoVehiculos(
        search: event.search,
      );

      if (response.data != null) {
        emit(CatalogoVehiculosLoaded(response.data!.vehiculos));
      } else {
        emit(VehiculosError(
            response.errorMessage ?? 'Failed to load catalog'));
      }
    } catch (e) {
      emit(VehiculosError('Error loading catalog: $e'));
    }
  }

  Future<void> _onAddCatalogoVehiculo(
      AddCatalogoVehiculoEvent event, Emitter<VehiculosState> emit) async {
    emit(const VehiculoSaving());

    try {
      final response = await vehiculosRepository.addCatalogoVehiculo(
        marca: event.marca,
        modelo: event.modelo,
        categoria: event.categoria,
      );

      if (response.data != null && response.data!['vehiculo_catalogo_id'] != null) {
        emit(CatalogoVehiculoAdded(
          'Vehículo agregado al catálogo exitosamente',
          response.data!['vehiculo_catalogo_id'],
        ));
        // Reload catalog to show the new vehicle
        add(LoadCatalogoVehiculosEvent(search: event.marca));
      } else {
        emit(VehiculosError(
            response.errorMessage ?? 'Failed to add vehicle to catalog'));
      }
    } catch (e) {
      emit(VehiculosError('Error adding vehicle to catalog: $e'));
    }
  }

  Future<void> _onAddClienteVehiculo(
      AddClienteVehiculoEvent event, Emitter<VehiculosState> emit) async {
    emit(const VehiculoSaving());

    try {
      final response = await vehiculosRepository.addClienteVehiculo(
        token: event.token,
        vehiculoId: event.vehiculoId,
        alias: event.alias,
        color: event.color,
        placas: event.placas,
      );

      if (response.data != null) {
        emit(const VehiculoSaved('Vehículo agregado exitosamente'));
        // Reload client vehicles after adding
        add(LoadClienteVehiculosEvent(event.token));
      } else {
        emit(VehiculosError(
            response.errorMessage ?? 'Failed to add vehicle'));
      }
    } catch (e) {
      emit(VehiculosError('Error adding vehicle: $e'));
    }
  }

  Future<void> _onDeleteClienteVehiculo(
      DeleteClienteVehiculoEvent event, Emitter<VehiculosState> emit) async {
    emit(const VehiculoSaving());

    try {
      final response = await vehiculosRepository.deleteClienteVehiculo(
        token: event.token,
        vehiculoClienteId: event.vehiculoClienteId,
      );

      if (response.data == true) {
        emit(const VehiculoDeleted('Vehículo eliminado exitosamente'));
        // Reload client vehicles after deleting
        add(LoadClienteVehiculosEvent(event.token));
      } else {
        emit(VehiculosError(
            response.errorMessage ?? 'Failed to delete vehicle'));
      }
    } catch (e) {
      emit(VehiculosError('Error deleting vehicle: $e'));
    }
  }

  Future<void> _onResetVehiculos(
      ResetVehiculosEvent event, Emitter<VehiculosState> emit) async {
    emit(const VehiculosInitial());
  }
}
