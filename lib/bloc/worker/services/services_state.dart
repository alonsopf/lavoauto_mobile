part of 'services_bloc.dart';

sealed class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object?> get props => [];
}

/// Initial state
final class ServicesInitial extends ServicesState {}

/// Loading state
final class ServicesLoading extends ServicesState {}

/// Success state for fetching available orders
final class ServicesSuccess extends ServicesState {
  final WorkerOrdersResponse workerOrdersResponse;

  const ServicesSuccess(this.workerOrdersResponse);
  ServicesSuccess copyWith({WorkerOrdersResponse? workerOrdersResponse}) {
    return ServicesSuccess(
      workerOrdersResponse ?? this.workerOrdersResponse,
    );
  }

  @override
  List<Object?> get props => [workerOrdersResponse];
}

/// Success state for fetching my work orders
final class MyWorkSuccess extends ServicesState {
  final MyWorkResponse myWorkResponse;

  const MyWorkSuccess(this.myWorkResponse);
  MyWorkSuccess copyWith({MyWorkResponse? myWorkResponse}) {
    return MyWorkSuccess(
      myWorkResponse ?? this.myWorkResponse,
    );
  }

  @override
  List<Object?> get props => [myWorkResponse];
}

/// Success state for collecting order
final class CollectOrderSuccess extends ServicesState {
  final String message;

  const CollectOrderSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Success state for delivering order
final class DeliverOrderSuccess extends ServicesState {
  final String message;

  const DeliverOrderSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Success state for fetching earnings
final class EarningsSuccess extends ServicesState {
  final EarningsResponse earningsResponse;

  const EarningsSuccess(this.earningsResponse);

  @override
  List<Object?> get props => [earningsResponse];
}

/// Failure state
final class ServicesFailure extends ServicesState {
  final String errorMessage;

  const ServicesFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
