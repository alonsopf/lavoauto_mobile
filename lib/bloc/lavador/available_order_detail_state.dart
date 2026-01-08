part of 'available_order_detail_bloc.dart';

@immutable
abstract class AvailableOrderDetailState extends Equatable {
  const AvailableOrderDetailState();
  
  @override
  List<Object> get props => [];
}

class AvailableOrderDetailInitial extends AvailableOrderDetailState {}

class AvailableOrderDetailLoading extends AvailableOrderDetailState {}

class AvailableOrderDetailSuccess extends AvailableOrderDetailState {
  final AvailableOrderDetailResponse orderDetail;

  const AvailableOrderDetailSuccess({required this.orderDetail});

  @override
  List<Object> get props => [orderDetail];
}

class AvailableOrderDetailFailure extends AvailableOrderDetailState {
  final String error;

  const AvailableOrderDetailFailure(this.error);

  @override
  List<Object> get props => [error];
}