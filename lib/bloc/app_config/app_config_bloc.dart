import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/app_config_repo.dart';
import '../../data/models/response/app_config/support_info_response_model.dart';

// Events
abstract class AppConfigEvent {}

class GetSupportInfoEvent extends AppConfigEvent {}

// States
abstract class AppConfigState {}

class AppConfigInitial extends AppConfigState {}

class AppConfigLoading extends AppConfigState {}

class SupportInfoLoaded extends AppConfigState {
  final SupportInfoResponse supportInfo;

  SupportInfoLoaded(this.supportInfo);
}

class AppConfigError extends AppConfigState {
  final String message;

  AppConfigError(this.message);
}

// BLoC
@injectable
class AppConfigBloc extends Bloc<AppConfigEvent, AppConfigState> {
  final AppConfigRepo _appConfigRepo;

  AppConfigBloc(this._appConfigRepo) : super(AppConfigInitial()) {
    on<GetSupportInfoEvent>(_onGetSupportInfo);
  }

  Future<void> _onGetSupportInfo(
    GetSupportInfoEvent event,
    Emitter<AppConfigState> emit,
  ) async {
    emit(AppConfigLoading());

    try {
      final response = await _appConfigRepo.getSupportInfo();
      if (response.data != null) {
        emit(SupportInfoLoaded(response.data!));
      } else {
        emit(AppConfigError(response.errorMessage ?? 'Failed to get support info'));
      }
    } catch (e) {
      emit(AppConfigError('Error getting support info: $e'));
    }
  }
}