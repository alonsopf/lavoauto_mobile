part of 'services_bloc.dart';

sealed class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch available orders
final class FetchServicesEvent extends ServicesEvent {
  final ListAvailableOrdersRequest request;

  const FetchServicesEvent(this.request);

  @override
  List<Object> get props => [request];
}

/// Event to fetch my work orders
final class FetchMyWorkEvent extends ServicesEvent {
  final MyWorkRequest request;

  const FetchMyWorkEvent(this.request);

  @override
  List<Object> get props => [request];
}

/// Event to collect order
final class CollectOrderEvent extends ServicesEvent {
  final CollectOrderRequest request;

  const CollectOrderEvent(this.request);

  @override
  List<Object> get props => [request];
}

/// Event to deliver order
final class DeliverOrderEvent extends ServicesEvent {
  final DeliverOrderRequest request;

  const DeliverOrderEvent(this.request);

  @override
  List<Object> get props => [request];
}

/// Event to fetch lavador earnings
final class FetchEarningsEvent extends ServicesEvent {
  final EarningsRequest request;

  const FetchEarningsEvent(this.request);

  @override
  List<Object> get props => [request];
}

/// Event to reset the state
final class ResetServicesEvent extends ServicesEvent {
  const ResetServicesEvent();
}
