import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/features/pages/clothes/models/clothes_model.dart';

import 'clothes_event.dart';
import 'clothes_state.dart';

class ClothesBloc extends Bloc<ClothesEvent, ClothesState> {
  ClothesBloc() : super(ClothesState(model: const ClothesModel())) {
    on<ChangeQuantity>((event, emit) {
      emit(state.copyWith(model: state.model.copyWith(quantity: event.quantity)));
    });

    on<ToggleClothesType>((event, emit) {
      switch (event.key) {
        case "ropaDiaria":
          emit(state.copyWith(model: state.model.copyWith(ropaDiaria: event.value)));
          break;
        case "ropaDelicada":
          emit(state.copyWith(model: state.model.copyWith(ropaDelicada: event.value)));
          break;
        case "blancos":
          emit(state.copyWith(model: state.model.copyWith(blancos: event.value)));
          break;
        case "ropaTrabajo":
          emit(state.copyWith(model: state.model.copyWith(ropaTrabajo: event.value)));
          break;
      }
    });

    on<ChangeNote>((event, emit) {
      emit(state.copyWith(model: state.model.copyWith(note: event.note)));
    });

    on<SubmitClothes>((event, emit) {
      emit(state.copyWith(submitted: true));
    });
  }
}
