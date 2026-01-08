import 'package:flutter_bloc/flutter_bloc.dart';

import 'gancho_event.dart';
import 'gancho_state.dart';

class GanchoBloc extends Bloc<GanchoEvent, GanchoState> {
  GanchoBloc() : super(const GanchoState()) {
    on<SelectGanchoOption>((event, emit) {
      emit(state.copyWith(selectedOption: event.option));
    });
  }
}
