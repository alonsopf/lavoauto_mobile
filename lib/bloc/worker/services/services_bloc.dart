import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/models/request/worker/availableOrdersRequest_modal.dart';
import '../../../data/models/request/worker/my_work_request_modal.dart';
import '../../../data/models/request/worker/collect_order_modal.dart';
import '../../../data/models/request/worker/deliver_order_modal.dart';
import '../../../data/models/request/worker/earnings_request_modal.dart';
import '../../../data/models/response/worker/orders_response_modal.dart';
import '../../../data/models/response/worker/my_work_response_modal.dart';
import '../../../data/models/response/worker/deliver_order_response_modal.dart';
import '../../../data/models/response/worker/earnings_response_modal.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../data/repositories/worker_repo.dart';
import '../../../data/models/api_response.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final WorkerRepo workerRepo;

  ServicesBloc({required this.workerRepo}) : super(ServicesInitial()) {
    on<FetchServicesEvent>(_fetchAvailableOrders);
    on<FetchMyWorkEvent>(_fetchMyWork);
    on<CollectOrderEvent>(_collectOrder);
    on<DeliverOrderEvent>(_deliverOrder);
    on<FetchEarningsEvent>(_fetchEarnings);
    on<ResetServicesEvent>(_resetState);
  }

  /// Fetch available orders and update state
  Future<void> _fetchAvailableOrders(
    FetchServicesEvent event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    try {
      debugPrint(
          "response of the available orders ${event.request.token} ${event.request.toJson()}");

      ApiResponse<WorkerOrdersResponse> availableOrders =
          await workerRepo.getMyServicesOrders(event.request);
      debugPrint(
          "response of the available orders: ${availableOrders.data?.toJson()}");
      if (availableOrders.data != null) {
        if (state is ServicesSuccess) {
          final currentState = state as ServicesSuccess;
          emit(currentState.copyWith(
              workerOrdersResponse: availableOrders.data));
        } else {
          emit(ServicesSuccess(
              availableOrders.data ?? WorkerOrdersResponse(orders: [])));
        }
      } else {
        emit(ServicesFailure(availableOrders.errorMessage ??
            "Failed to fetch available orders"));
      }
    } catch (e) {
      // Emit failure state with the error message
      emit(ServicesFailure(e.toString()));
    }
  }

  /// Fetch my work orders and update state
  Future<void> _fetchMyWork(
    FetchMyWorkEvent event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    try {
      debugPrint(
          "response of my work ${event.request.token} ${event.request.toJson()}");

      ApiResponse<MyWorkResponse> myWorkResponse =
          await workerRepo.getMyWork(event.request);
      debugPrint(
          "response of my work: ${myWorkResponse.data?.toJson()}");
      if (myWorkResponse.data != null) {
        emit(MyWorkSuccess(myWorkResponse.data!));
      } else {
        emit(ServicesFailure(myWorkResponse.errorMessage ??
            "Failed to fetch my work orders"));
      }
    } catch (e) {
      // Emit failure state with the error message
      emit(ServicesFailure(e.toString()));
    }
  }

  /// Collect order and update state
  Future<void> _collectOrder(
    CollectOrderEvent event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    try {
      debugPrint(
          "Collecting order ${event.request.ordenId} with data: ${event.request.toJson()}");

      ApiResponse<bool> collectResponse =
          await workerRepo.collectOrder(event.request);
      debugPrint("Collect order response: ${collectResponse.data}");
      
      if (collectResponse.data == true) {
        emit(CollectOrderSuccess("Orden recolectada exitosamente"));
      } else {
        emit(ServicesFailure(collectResponse.errorMessage ??
            "Failed to collect order"));
      }
    } catch (e) {
      // Emit failure state with the error message
      emit(ServicesFailure(e.toString()));
    }
  }

  /// Deliver order and update state
  Future<void> _deliverOrder(
    DeliverOrderEvent event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    try {
      debugPrint(
          "Delivering order ${event.request.ordenId} with data: ${event.request.toJson()}");

      ApiResponse<DeliverOrderResponse> deliverResponse =
          await workerRepo.deliverOrder(event.request);
      debugPrint("Deliver order response: ${deliverResponse.data?.toJson()}");

      if (deliverResponse.data != null) {
        emit(DeliverOrderSuccess(deliverResponse.data!.message));
      } else {
        emit(ServicesFailure(deliverResponse.errorMessage ??
            "Failed to deliver order"));
      }
    } catch (e) {
      // Emit failure state with the error message
      emit(ServicesFailure(e.toString()));
    }
  }

  /// Fetch earnings and update state
  Future<void> _fetchEarnings(
    FetchEarningsEvent event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    try {
      debugPrint(
          "Fetching earnings with token: ${event.request.token}");

      ApiResponse<EarningsResponse> earningsResponse =
          await workerRepo.getEarnings(event.request);
      debugPrint("Earnings response: ${earningsResponse.data?.toJson()}");

      if (earningsResponse.data != null) {
        emit(EarningsSuccess(earningsResponse.data!));
      } else {
        emit(ServicesFailure(earningsResponse.errorMessage ??
            "Failed to fetch earnings"));
      }
    } catch (e) {
      // Emit failure state with the error message
      emit(ServicesFailure(e.toString()));
    }
  }

  /// Reset state to initial
  void _resetState(
    ResetServicesEvent event,
    Emitter<ServicesState> emit,
  ) {
    emit(ServicesInitial());
  }
}
