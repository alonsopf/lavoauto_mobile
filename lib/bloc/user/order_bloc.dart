import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lavoauto/data/models/request/user/accept_bid_order_modal.dart';

import '../../../data/repositories/auth_repo.dart';
import '../../data/models/request/user/create_user_order_modal.dart';
import '../../data/models/request/user/order_bids_modal.dart';
import '../../data/models/request/user/orders_modal.dart';
import '../../data/models/response/user/create_order_response_modal.dart';
import '../../data/models/response/user/order_bid_accept_response_modal.dart';
import '../../data/models/response/user/order_bids_response_modal.dart';
import '../../data/models/response/user/orders_response_modal.dart';
import '../../data/repositories/user_repo.dart';
import '../../data/models/api_response.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final UserRepo userRepo;

  OrderBloc({required this.userRepo}) : super(OrderInitial()) {
    on<CreateOrderEvent>(_createOrder);
    on<FetchOrderRequestsEvent>(_fetchOrderRequests);

    on<FetchOrderBidsEvent>(_fetchOrderBids);
    on<AcceptBidEvent>(_acceptBidEvent);

    on<OrderInitialEvent>((event, emit) {
      emit(OrderInitial());
    });
  }

  /// Fetch available orders and update state
  Future<void> _createOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    debugPrint("🏗️ OrderBloc: _createOrder iniciado");
    // Removed OrderLoading() emission as requested by user
    try {
      debugPrint("🏗️ OrderBloc: Llamando userRepo.createOrder");
      debugPrint("🏗️ OrderBloc: Request data: ${event.request.toJson()}");
      
      ApiResponse<CreateOrderResponse> createOrderResponse =
          await userRepo.createOrder(event.request);
          
      debugPrint("🏗️ OrderBloc: Respuesta recibida");
      debugPrint("🏗️ OrderBloc: createOrderResponse.data = ${createOrderResponse.data}");
      debugPrint("🏗️ OrderBloc: createOrderResponse.errorMessage = ${createOrderResponse.errorMessage}");
      
      if (createOrderResponse.data != null) {
        debugPrint("🏗️ OrderBloc: Datos válidos, emitiendo OrderSuccess");
        debugPrint("🏗️ OrderBloc: Orden creada con ID: ${createOrderResponse.data!.ordenId}");
        
        // Siempre emitir un nuevo estado OrderSuccess con solo la respuesta de crear orden
        // No mantener estados anteriores que puedan confundir
        emit(OrderSuccess(orderResponse: createOrderResponse.data));
      } else {
        debugPrint("🏗️ OrderBloc: Error en respuesta: ${createOrderResponse.errorMessage}");
        emit(OrderFailure(
            createOrderResponse.errorMessage ?? "Failed to create order"));
      }
    } catch (e) {
      // Emit failure state with the error message
      debugPrint("🏗️ OrderBloc: Excepción capturada: $e");
      emit(OrderFailure(e.toString()));
    }
  }

  Future<void> _fetchOrderRequests(
    FetchOrderRequestsEvent event,
    Emitter<OrderState> emit,
  ) async {
    // Removed OrderLoading() emission as requested by user
    try {
      debugPrint(
          "response of the available orders ${event.request.token} ${event.request.toJson()}");

      ApiResponse<UserOrdersResponse> availableOrders =
          await userRepo.getOrders(event.request);
      debugPrint(
          "response of the available orders: ${availableOrders.data?.toJson()}");
      if (availableOrders.data != null) {
        if (state is OrderSuccess) {
          final currentState = state as OrderSuccess;
          emit(currentState.copyWith(userOrdersResponse: availableOrders.data));
        } else {
          emit(OrderSuccess(userOrdersResponse: availableOrders.data));
        }
      } else {
        emit(OrderFailure(availableOrders.errorMessage ??
            "Failed to fetch available orders"));
      }
    } catch (e) {
      // Emit failure state with the error message
      emit(OrderFailure(e.toString()));
    }
  }

  Future<void> _fetchOrderBids(
    FetchOrderBidsEvent event,
    Emitter<OrderState> emit,
  ) async {
    OrderSuccess? currentOldState;
    if (state is OrderSuccess) {
      currentOldState = state as OrderSuccess;
    }
    // Removed OrderLoading() emission to prevent loading state issues
    try {
      debugPrint(
          "response of the available orders ${event.request.token} ${event.request.toJson()}");

      ApiResponse<OrderBidsResponse> availableOrders =
          await userRepo.getOrderBids(event.request);
      debugPrint(
          "response of the available orders: ${availableOrders.data?.toJson()}");
      if (availableOrders.data != null) {
        if (state is OrderSuccess) {
          final currentState = state as OrderSuccess;
          emit(currentState.copyWith(
              orderBidsResponse: availableOrders.data,
              orderResponse: currentState.orderResponse,
              userOrdersResponse: currentState.userOrdersResponse));
        } else {
          emit(OrderSuccess(
              orderBidsResponse: availableOrders.data,
              userOrdersResponse: currentOldState?.userOrdersResponse));
        }
      } else {
        emit(OrderFailure(availableOrders.errorMessage ??
            "Failed to fetch available orders"));
      }
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  Future<void> _acceptBidEvent(
    AcceptBidEvent event,
    Emitter<OrderState> emit,
  ) async {
    // Removed OrderLoading() emission to prevent loading state issues
    try {
      ApiResponse<OrderBidAcceptResponse> orderBidAcceptResponse =
          await userRepo.acceptBid(event.request);
      if (orderBidAcceptResponse.data != null) {
        if (state is OrderSuccess) {
          final currentState = state as OrderSuccess;
          emit(currentState.copyWith(
              orderBidAcceptResponse: orderBidAcceptResponse.data));
        } else {
          emit(OrderSuccess(
              orderBidAcceptResponse: orderBidAcceptResponse.data));
        }
      } else {
        emit(OrderFailure(
            orderBidAcceptResponse.errorMessage ?? "Failed to create order"));
      }
    } catch (e) {
      // Emit failure state with the error message
      emit(OrderFailure(e.toString()));
    }
  }
}
