import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/orden_repository.dart';
import 'lavador_ordenes_event.dart';
import 'lavador_ordenes_state.dart';

@injectable
class LavadorOrdenesBloc
    extends Bloc<LavadorOrdenesEvent, LavadorOrdenesState> {
  final OrdenRepository ordenRepository;

  LavadorOrdenesBloc(this.ordenRepository)
      : super(const LavadorOrdenesInitial()) {
    on<LoadOrdenesPendientesEvent>(_onLoadOrdenesPendientes);
    on<LoadOrdenesActivasEvent>(_onLoadOrdenesActivas);
    on<ComenzarServicioEvent>(_onComenzarServicio);
    on<CompletarServicioEvent>(_onCompletarServicio);
    on<ResetLavadorOrdenesEvent>(_onResetLavadorOrdenes);
  }

  Future<void> _onLoadOrdenesPendientes(
    LoadOrdenesPendientesEvent event,
    Emitter<LavadorOrdenesState> emit,
  ) async {
    emit(const LavadorOrdenesLoading());

    try {
      final response =
          await ordenRepository.getLavadorOrdenesPendientes(event.token);

      if (response.data != null) {
        emit(OrdenesPendientesLoaded(response.data!.ordenes));
      } else {
        emit(LavadorOrdenesError(
          response.errorMessage ?? 'No se pudieron cargar las órdenes',
        ));
      }
    } catch (e) {
      emit(LavadorOrdenesError('Error al cargar órdenes: $e'));
    }
  }

  Future<void> _onLoadOrdenesActivas(
    LoadOrdenesActivasEvent event,
    Emitter<LavadorOrdenesState> emit,
  ) async {
    emit(const LavadorOrdenesLoading());

    try {
      // TODO: Create specific endpoint for active orders
      // For now, we'll fetch all and filter by status in_progress
      final response = await ordenRepository.getMisOrdenes(
        event.token,
        statusFilter: 'in_progress',
      );

      if (response.data != null) {
        emit(OrdenesActivasLoaded(response.data!.ordenes));
      } else {
        emit(LavadorOrdenesError(
          response.errorMessage ?? 'No se pudieron cargar las órdenes activas',
        ));
      }
    } catch (e) {
      emit(LavadorOrdenesError('Error al cargar órdenes activas: $e'));
    }
  }

  Future<void> _onComenzarServicio(
    ComenzarServicioEvent event,
    Emitter<LavadorOrdenesState> emit,
  ) async {
    emit(const LavadorOrdenesLoading());

    try {
      final response = await ordenRepository.comenzarServicio(
        token: event.token,
        ordenId: event.ordenId,
      );

      if (response.data != null) {
        emit(ServicioIniciado(
          response.data!['message'] ?? 'Servicio iniciado exitosamente',
        ));
        // Reload orders after starting service
        add(LoadOrdenesPendientesEvent(event.token));
      } else {
        emit(LavadorOrdenesError(
          response.errorMessage ?? 'No se pudo iniciar el servicio',
        ));
      }
    } catch (e) {
      emit(LavadorOrdenesError('Error al iniciar servicio: $e'));
    }
  }

  Future<void> _onCompletarServicio(
    CompletarServicioEvent event,
    Emitter<LavadorOrdenesState> emit,
  ) async {
    emit(const LavadorOrdenesLoading());

    try {
      final response = await ordenRepository.completarServicio(
        token: event.token,
        ordenId: event.ordenId,
      );

      if (response.data != null) {
        emit(ServicioCompletado(
          response.data!['message'] ?? 'Servicio completado exitosamente',
        ));
        // Reload orders after completing service
        add(LoadOrdenesPendientesEvent(event.token));
      } else {
        emit(LavadorOrdenesError(
          response.errorMessage ?? 'No se pudo completar el servicio',
        ));
      }
    } catch (e) {
      emit(LavadorOrdenesError('Error al completar servicio: $e'));
    }
  }

  Future<void> _onResetLavadorOrdenes(
    ResetLavadorOrdenesEvent event,
    Emitter<LavadorOrdenesState> emit,
  ) async {
    emit(const LavadorOrdenesInitial());
  }
}
