import 'package:flutter_bloc/flutter_bloc.dart';

import 'wash_event.dart';
import 'wash_state.dart';

class WashBloc extends Bloc<WashEvent, WashState> {
  WashBloc() : super(const WashState()) {
    on<SelectDetergent>((event, emit) {
      emit(state.copyWith(selectedDetergent: event.detergent));
    });

    on<ToggleSoftener>((event, emit) {
      emit(state.copyWith(softener: event.value));
    });

    on<SelectTemperature>((event, emit) {
      emit(state.copyWith(temperature: event.temp));
    });

    on<UpdateFragranceNote>((event, emit) {
      emit(state.copyWith(fragranceNote: event.note));
    });
  }
}
