part of 'jobsearch_bloc.dart';

sealed class JobsearchState extends Equatable {
  const JobsearchState();

  @override
  List<Object?> get props => [];
}

/// Initial state
final class JobsearchInitial extends JobsearchState {}

/// Loading state
final class JobsearchLoading extends JobsearchState {}

/// Success state for fetching available orders
final class JobsearchSuccess extends JobsearchState {
  final WorkerOrdersResponse workerOrdersResponse;
  final OrderBidResponse? orderBidResponse;

  const JobsearchSuccess(this.workerOrdersResponse, {this.orderBidResponse});
  
  JobsearchSuccess copyWith({
    WorkerOrdersResponse? workerOrdersResponse,
    OrderBidResponse? orderBidResponse,
  }) {
    return JobsearchSuccess(
      workerOrdersResponse ?? this.workerOrdersResponse,
      orderBidResponse: orderBidResponse ?? this.orderBidResponse,
    );
  }

  @override
  List<Object?> get props => [workerOrdersResponse, orderBidResponse];
}

/// Failure state
final class JobsearchFailure extends JobsearchState {
  final String errorMessage;

  const JobsearchFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
