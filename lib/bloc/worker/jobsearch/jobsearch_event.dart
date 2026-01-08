part of 'jobsearch_bloc.dart';

sealed class JobsearchEvent extends Equatable {
  const JobsearchEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch available orders
final class FetchAvailableOrdersEvent extends JobsearchEvent {
  final ListAvailableOrdersRequest request;

  const FetchAvailableOrdersEvent(this.request);

  @override
  List<Object> get props => [request];
}

/// Event to create a bid for an order
final class CreateBidEvent extends JobsearchEvent {
  final CreateBidRequest request;

  const CreateBidEvent(this.request);

  @override
  List<Object> get props => [request];
}

/// Event to reset the state after successful bid creation
final class ResetJobsearchStateEvent extends JobsearchEvent {
  const ResetJobsearchStateEvent();
}
