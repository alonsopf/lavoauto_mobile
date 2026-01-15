import 'package:equatable/equatable.dart';

abstract class OrdenesEvent extends Equatable {
  const OrdenesEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all orders for cliente
class LoadMisOrdenesEvent extends OrdenesEvent {
  final String token;
  final String? statusFilter; // 'pending', 'in_progress', 'completed'

  const LoadMisOrdenesEvent(this.token, {this.statusFilter});

  @override
  List<Object?> get props => [token, statusFilter];
}

/// Event to load order detail
class LoadOrdenDetailEvent extends OrdenesEvent {
  final int ordenId;

  const LoadOrdenDetailEvent(this.ordenId);

  @override
  List<Object?> get props => [ordenId];
}

/// Event to reset ordenes state
class ResetOrdenesEvent extends OrdenesEvent {
  const ResetOrdenesEvent();
}
