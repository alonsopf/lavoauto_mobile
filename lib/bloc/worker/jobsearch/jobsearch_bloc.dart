import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/models/request/worker/availableOrdersRequest_modal.dart';
import '../../../data/models/request/worker/create_bid_modal.dart';
import '../../../data/models/response/worker/orders_response_modal.dart';
import '../../../data/models/response/worker/order_bid_response_modal.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../data/repositories/worker_repo.dart';
import '../../../data/models/api_response.dart';

part 'jobsearch_event.dart';
part 'jobsearch_state.dart';

class JobsearchBloc extends Bloc<JobsearchEvent, JobsearchState> {
  final WorkerRepo workerRepo;

  JobsearchBloc({required this.workerRepo}) : super(JobsearchInitial()) {
    on<FetchAvailableOrdersEvent>(_fetchAvailableOrders);
    on<CreateBidEvent>(_createBid);
    on<ResetJobsearchStateEvent>(_resetState);
  }

  /// Fetch available orders and update state
  Future<void> _fetchAvailableOrders(
    FetchAvailableOrdersEvent event,
    Emitter<JobsearchState> emit,
  ) async {
    emit(JobsearchLoading());
    try {
      debugPrint(
          "response of the available orders ${event.request.token} ${event.request.toJson()}");

      ApiResponse<WorkerOrdersResponse> availableOrders =
          await workerRepo.listAvailableOrders(event.request);
      debugPrint(
          "response of the available orders: ${availableOrders.data?.toJson()}");
      if (availableOrders.data != null) {
        if (state is JobsearchSuccess) {
          final currentState = state as JobsearchSuccess;
          emit(currentState.copyWith(
              workerOrdersResponse: availableOrders.data));
        } else {
          emit(JobsearchSuccess(
              availableOrders.data ?? WorkerOrdersResponse(orders: [])));
        }
      } else {
        emit(JobsearchFailure(availableOrders.errorMessage ??
            "Failed to fetch available orders"));
      }
    } catch (e) {
      // Emit failure state with the error message
      emit(JobsearchFailure(e.toString()));
    }
  }

  /// Create a bid for an order
  Future<void> _createBid(
    CreateBidEvent event,
    Emitter<JobsearchState> emit,
  ) async {
    emit(JobsearchLoading());
    try {
      debugPrint("Creating bid with request: ${event.request.toJson()}");

      ApiResponse<OrderBidResponse> bidResponse =
          await workerRepo.createBid(event.request);
      debugPrint("Bid response: ${bidResponse.data?.toJson()}");
      
      if (bidResponse.data != null) {
        if (state is JobsearchSuccess) {
          final currentState = state as JobsearchSuccess;
          emit(currentState.copyWith(orderBidResponse: bidResponse.data));
        } else {
          emit(JobsearchSuccess(
            WorkerOrdersResponse(orders: []),
            orderBidResponse: bidResponse.data,
          ));
        }
      } else {
        emit(JobsearchFailure(bidResponse.errorMessage ?? "Failed to create bid"));
      }
    } catch (e) {
      emit(JobsearchFailure(e.toString()));
    }
  }

  /// Reset the BLoC state to initial
  Future<void> _resetState(
    ResetJobsearchStateEvent event,
    Emitter<JobsearchState> emit,
  ) async {
    emit(JobsearchInitial());
  }
}
