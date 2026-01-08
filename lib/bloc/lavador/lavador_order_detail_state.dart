part of 'lavador_order_detail_bloc.dart';

abstract class LavadorOrderDetailState extends Equatable {
  const LavadorOrderDetailState();

  @override
  List<Object?> get props => [];
}

class LavadorOrderDetailInitial extends LavadorOrderDetailState {}

class LavadorOrderDetailLoading extends LavadorOrderDetailState {}

class LavadorOrderDetailSuccess extends LavadorOrderDetailState {
  final LavadorOrderDetailResponse orderDetail;

  const LavadorOrderDetailSuccess({required this.orderDetail});

  @override
  List<Object?> get props => [orderDetail];
}

class LavadorOrderDetailFailure extends LavadorOrderDetailState {
  final String errorMessage;

  const LavadorOrderDetailFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}