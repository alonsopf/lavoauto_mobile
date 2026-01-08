part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

/// Initial state
final class OrderInitial extends OrderState {}

/// Loading state
final class OrderLoading extends OrderState {}

/// Success state for fetching available orders
final class OrderSuccess extends OrderState {
  final CreateOrderResponse? orderResponse;
  final UserOrdersResponse? userOrdersResponse;
  final OrderBidsResponse? orderBidsResponse;
  final OrderBidAcceptResponse? orderBidAcceptResponse;
  const OrderSuccess(
      {this.orderResponse,
      this.userOrdersResponse,
      this.orderBidAcceptResponse,
      this.orderBidsResponse});
  OrderSuccess copyWith(
      {CreateOrderResponse? orderResponse,
      UserOrdersResponse? userOrdersResponse,
      OrderBidAcceptResponse? orderBidAcceptResponse,
      OrderBidsResponse? orderBidsResponse}) {
    return OrderSuccess(
        orderBidsResponse: orderBidsResponse ?? this.orderBidsResponse,
        orderResponse: orderResponse ?? this.orderResponse,
        orderBidAcceptResponse:
            orderBidAcceptResponse ?? this.orderBidAcceptResponse,
        userOrdersResponse: userOrdersResponse ?? this.userOrdersResponse);
  }

  @override
  List<Object?> get props => [
        orderResponse,
        userOrdersResponse,
        orderBidsResponse,
        orderBidAcceptResponse, 
        orderBidAcceptResponse
      ];
}

/// Failure state
final class OrderFailure extends OrderState {
  final String errorMessage;

  const OrderFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
