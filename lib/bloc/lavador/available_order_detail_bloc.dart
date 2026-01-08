import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lavoauto/data/models/request/lavador/available_order_detail_modal.dart';
import 'package:lavoauto/data/models/response/lavador/available_order_detail_response_modal.dart';
import 'package:lavoauto/data/repositories/auth_repo.dart';
import 'package:lavoauto/data/repositories/worker_repo.dart';
import '../../data/models/api_response.dart';

part 'available_order_detail_event.dart';
part 'available_order_detail_state.dart';

@injectable
class AvailableOrderDetailBloc extends Bloc<AvailableOrderDetailEvent, AvailableOrderDetailState> {
  final WorkerRepo workerRepo;

  AvailableOrderDetailBloc({required this.workerRepo}) : super(AvailableOrderDetailInitial()) {
    on<FetchAvailableOrderDetailEvent>(_fetchAvailableOrderDetail);
    on<AvailableOrderDetailInitialEvent>((event, emit) {
      emit(AvailableOrderDetailInitial());
    });
  }

  Future<void> _fetchAvailableOrderDetail(
    FetchAvailableOrderDetailEvent event,
    Emitter<AvailableOrderDetailState> emit,
  ) async {
    debugPrint("🔍 AvailableOrderDetailBloc: _fetchAvailableOrderDetail iniciado");
    
    emit(AvailableOrderDetailLoading());
    
    try {
      debugPrint("🔍 AvailableOrderDetailBloc: Llamando workerRepo.getAvailableOrderDetail");
      debugPrint("🔍 AvailableOrderDetailBloc: Request data: ${event.request.toJson()}");
      
      ApiResponse<AvailableOrderDetailResponse> orderDetailResponse =
          await workerRepo.getAvailableOrderDetail(event.request);
          
      debugPrint("🔍 AvailableOrderDetailBloc: Respuesta recibida");
      debugPrint("🔍 AvailableOrderDetailBloc: orderDetailResponse.data = ${orderDetailResponse.data}");
      debugPrint("🔍 AvailableOrderDetailBloc: orderDetailResponse.errorMessage = ${orderDetailResponse.errorMessage}");
      
      if (orderDetailResponse.data != null) {
        debugPrint("🔍 AvailableOrderDetailBloc: Datos válidos, emitiendo AvailableOrderDetailSuccess");
        debugPrint("🔍 AvailableOrderDetailBloc: Orden ID: ${orderDetailResponse.data!.ordenId}");
        
        emit(AvailableOrderDetailSuccess(orderDetail: orderDetailResponse.data!));
      } else {
        debugPrint("🔍 AvailableOrderDetailBloc: Error en respuesta: ${orderDetailResponse.errorMessage}");
        emit(AvailableOrderDetailFailure(
            orderDetailResponse.errorMessage ?? "Failed to fetch available order detail"));
      }
    } catch (e) {
      debugPrint("🔍 AvailableOrderDetailBloc: Excepción capturada: $e");
      emit(AvailableOrderDetailFailure(e.toString()));
    }
  }
}