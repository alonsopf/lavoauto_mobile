import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/features/pages/service/bloc/service_event.dart';
import 'package:lavoauto/features/pages/service/bloc/service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ServiceBloc() : super(ServiceState()) {
    on<SelectService>((event, emit) {
      emit(state.copyWith(selectedService: event.service));
    });

    on<SelectDate>((event, emit) {
      emit(state.copyWith(selectedDate: event.date));
    });
  }
}
