import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/orden_repository.dart';
import 'ordenes_event.dart';
import 'ordenes_state.dart';

@injectable
class OrdenesBloc extends Bloc<OrdenesEvent, OrdenesState> {
  final OrdenRepository ordenRepository;

  OrdenesBloc(this.ordenRepository) : super(const OrdenesInitial()) {
    on<LoadMisOrdenesEvent>(_onLoadMisOrdenes);
    on<LoadOrdenDetailEvent>(_onLoadOrdenDetail);
    on<ResetOrdenesEvent>(_onResetOrdenes);
  }

  Future<void> _onLoadMisOrdenes(
    LoadMisOrdenesEvent event,
    Emitter<OrdenesState> emit,
  ) async {
    emit(const OrdenesLoading());

    try {
      final response = await ordenRepository.getMisOrdenes(
        event.token,
        statusFilter: event.statusFilter,
      );

      if (response.data != null) {
        emit(MisOrdenesLoaded(
          response.data!.ordenes,
          statusFilter: event.statusFilter,
        ));
      } else {
        emit(OrdenesError(
          response.errorMessage ?? 'No se pudieron cargar las órdenes',
        ));
      }
    } catch (e) {
      emit(OrdenesError('Error al cargar órdenes: $e'));
    }
  }

  Future<void> _onLoadOrdenDetail(
    LoadOrdenDetailEvent event,
    Emitter<OrdenesState> emit,
  ) async {
    emit(const OrdenesLoading());

    try {
      // For now, we'll need to load all orders and filter by ID
      // In the future, we could add a specific endpoint for order detail
      // TODO: Implement orden detail endpoint in backend

      emit(const OrdenesError('Detalle de orden no implementado aún'));
    } catch (e) {
      emit(OrdenesError('Error al cargar detalle: $e'));
    }
  }

  Future<void> _onResetOrdenes(
    ResetOrdenesEvent event,
    Emitter<OrdenesState> emit,
  ) async {
    emit(const OrdenesInitial());
  }
}
