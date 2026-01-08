import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lavoauto/data/models/request/lavador/lavador_order_detail_modal.dart';
import 'package:lavoauto/data/models/response/lavador/lavador_order_detail_response_modal.dart';
import 'package:lavoauto/data/repositories/auth_repo.dart';
import 'package:lavoauto/data/repositories/worker_repo.dart';
import '../../data/models/api_response.dart';

part 'lavador_order_detail_event.dart';
part 'lavador_order_detail_state.dart';

@injectable
class LavadorOrderDetailBloc extends Bloc<LavadorOrderDetailEvent, LavadorOrderDetailState> {
  final WorkerRepo workerRepo;

  LavadorOrderDetailBloc({required this.workerRepo}) : super(LavadorOrderDetailInitial()) {
    on<FetchLavadorOrderDetailEvent>(_fetchOrderDetail);
    on<LavadorOrderDetailInitialEvent>((event, emit) {
      emit(LavadorOrderDetailInitial());
    });
  }

  Future<void> _fetchOrderDetail(
    FetchLavadorOrderDetailEvent event,
    Emitter<LavadorOrderDetailState> emit,
  ) async {
    debugPrint("🔍 LavadorOrderDetailBloc: _fetchOrderDetail iniciado");
    
    try {
      debugPrint("🔍 LavadorOrderDetailBloc: Llamando workerRepo.getOrderDetail");
      debugPrint("🔍 LavadorOrderDetailBloc: Request data: ${event.request.toJson()}");
      
      ApiResponse<LavadorOrderDetailResponse> orderDetailResponse =
          await workerRepo.getOrderDetail(event.request);
          
      debugPrint("🔍 LavadorOrderDetailBloc: Respuesta recibida");
      debugPrint("🔍 LavadorOrderDetailBloc: orderDetailResponse.data = ${orderDetailResponse.data}");
      debugPrint("🔍 LavadorOrderDetailBloc: orderDetailResponse.errorMessage = ${orderDetailResponse.errorMessage}");
      
      if (orderDetailResponse.data != null) {
        debugPrint("🔍 LavadorOrderDetailBloc: Datos válidos, emitiendo LavadorOrderDetailSuccess");
        debugPrint("🔍 LavadorOrderDetailBloc: Orden ID: ${orderDetailResponse.data!.ordenId}");
        
        emit(LavadorOrderDetailSuccess(orderDetail: orderDetailResponse.data!));
      } else {
        debugPrint("🔍 LavadorOrderDetailBloc: Error en respuesta: ${orderDetailResponse.errorMessage}");
        emit(LavadorOrderDetailFailure(
            orderDetailResponse.errorMessage ?? "Failed to fetch order detail"));
      }
    } catch (e) {
      debugPrint("🔍 LavadorOrderDetailBloc: Excepción capturada: $e");
      emit(LavadorOrderDetailFailure(e.toString()));
    }
  }
}