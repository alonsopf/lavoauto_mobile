part of 'lavador_order_detail_bloc.dart';

abstract class LavadorOrderDetailEvent extends Equatable {
  const LavadorOrderDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchLavadorOrderDetailEvent extends LavadorOrderDetailEvent {
  final LavadorOrderDetailRequest request;

  const FetchLavadorOrderDetailEvent(this.request);

  @override
  List<Object> get props => [request];
}

class LavadorOrderDetailInitialEvent extends LavadorOrderDetailEvent {
  const LavadorOrderDetailInitialEvent();
}