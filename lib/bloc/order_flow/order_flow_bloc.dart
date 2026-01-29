import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/order_flow_repository.dart';
import '../../data/repositories/vehiculos_repository.dart';
import 'order_flow_event.dart';
import 'order_flow_state.dart';

@injectable
class OrderFlowBloc extends Bloc<OrderFlowEvent, OrderFlowState> {
  final VehiculosRepository vehiculosRepository;
  final OrderFlowRepository orderFlowRepository;

  // Store selected vehicle info for passing between steps
  int? _selectedVehiculoId;
  String? _selectedVehiculoInfo;
  String? _selectedCategoriaVehiculo;

  OrderFlowBloc(
    this.vehiculosRepository,
    this.orderFlowRepository,
  ) : super(const OrderFlowInitial()) {
    on<LoadClienteVehiculosForOrderEvent>(_onLoadClienteVehiculosForOrder);
    on<SelectVehiculoEvent>(_onSelectVehiculo);
    on<LoadLavadoresCercanosEvent>(_onLoadLavadoresCercanos);
    on<SelectLavadorEvent>(_onSelectLavador);
    on<ResetOrderFlowEvent>(_onResetOrderFlow);
  }

  Future<void> _onLoadClienteVehiculosForOrder(
    LoadClienteVehiculosForOrderEvent event,
    Emitter<OrderFlowState> emit,
  ) async {
    emit(const OrderFlowLoading());

    try {
      final response = await vehiculosRepository.getClienteVehiculos(event.token);

      if (response.data != null) {
        emit(ClienteVehiculosLoadedForOrder(response.data!.vehiculos));
      } else {
        emit(OrderFlowError(
          response.errorMessage ?? 'No se pudieron cargar tus vehículos',
        ));
      }
    } catch (e) {
      emit(OrderFlowError('Error al cargar vehículos: $e'));
    }
  }

  Future<void> _onSelectVehiculo(
    SelectVehiculoEvent event,
    Emitter<OrderFlowState> emit,
  ) async {
    // Store selected vehicle for later use
    _selectedVehiculoId = event.vehiculoClienteId;
    _selectedVehiculoInfo = event.vehiculoInfo;
    _selectedCategoriaVehiculo = event.categoriaVehiculo;

    emit(VehiculoSelectedForOrder(
      vehiculoClienteId: event.vehiculoClienteId,
      vehiculoInfo: event.vehiculoInfo,
      categoriaVehiculo: event.categoriaVehiculo,
    ));
  }

  Future<void> _onLoadLavadoresCercanos(
    LoadLavadoresCercanosEvent event,
    Emitter<OrderFlowState> emit,
  ) async {
    emit(const OrderFlowLoading());

    try {
      // Use category from event, or from stored state, or empty string
      final categoria = event.categoriaVehiculo.isNotEmpty
          ? event.categoriaVehiculo
          : (_selectedCategoriaVehiculo ?? '');

      final response = await orderFlowRepository.getLavadoresCercanos(
        event.token,
        categoriaVehiculo: categoria.isNotEmpty ? categoria : null,
        forceRecalc: event.forceRecalc,
      );

      if (response.data != null) {
        emit(LavadoresCercanosLoaded(
          lavadores: response.data!.lavadores,
          vehiculoClienteId: _selectedVehiculoId ?? 0,
          vehiculoInfo: _selectedVehiculoInfo ?? '',
          categoriaVehiculo: categoria,
          clienteDireccion: response.data!.clienteDireccion,
        ));
      } else {
        emit(OrderFlowError(
          response.errorMessage ?? 'No se pudieron cargar lavadores cercanos',
        ));
      }
    } catch (e) {
      emit(OrderFlowError('Error al cargar lavadores: $e'));
    }
  }

  Future<void> _onSelectLavador(
    SelectLavadorEvent event,
    Emitter<OrderFlowState> emit,
  ) async {
    emit(LavadorSelectedForOrder(
      vehiculoClienteId: _selectedVehiculoId!,
      vehiculoInfo: _selectedVehiculoInfo!,
      lavadorId: event.lavadorId,
      lavadorNombre: event.lavadorNombre,
      distanciaKm: event.distanciaKm,
      precioKm: event.precioKm,
    ));
  }

  Future<void> _onResetOrderFlow(
    ResetOrderFlowEvent event,
    Emitter<OrderFlowState> emit,
  ) async {
    _selectedVehiculoId = null;
    _selectedVehiculoInfo = null;
    _selectedCategoriaVehiculo = null;
    emit(const OrderFlowInitial());
  }
}
