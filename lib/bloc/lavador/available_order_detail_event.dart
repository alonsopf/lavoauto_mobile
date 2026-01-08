part of 'available_order_detail_bloc.dart';

@immutable
abstract class AvailableOrderDetailEvent extends Equatable {
  const AvailableOrderDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchAvailableOrderDetailEvent extends AvailableOrderDetailEvent {
  final AvailableOrderDetailRequest request;

  const FetchAvailableOrderDetailEvent(this.request);

  @override
  List<Object> get props => [request];
}

class AvailableOrderDetailInitialEvent extends AvailableOrderDetailEvent {
  const AvailableOrderDetailInitialEvent();
}