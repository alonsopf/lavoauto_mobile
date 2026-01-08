part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

final class OrderInitialEvent extends OrderEvent {
  const OrderInitialEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch available orders
final class CreateOrderEvent extends OrderEvent {
  final CreateUserOrderRequest request;

  const CreateOrderEvent(this.request);

  @override
  List<Object> get props => [request];
}

final class FetchOrderRequestsEvent extends OrderEvent {
  final GetOrderRequests request;

  const FetchOrderRequestsEvent(this.request);

  @override
  List<Object> get props => [request];
}


final class FetchOrderBidsEvent extends OrderEvent {
  final ListOrderBidsRequest request;

  const FetchOrderBidsEvent(this.request);

  @override
  List<Object> get props => [request];
}

final class AcceptBidEvent extends OrderEvent {
  final AcceptBidOrderRequest request;

  const AcceptBidEvent(this.request);

  @override
  List<Object> get props => [request];
}
