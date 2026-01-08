import 'package:lavoauto/features/pages/clothes/models/clothes_model.dart';

class ClothesState {
  final ClothesModel model;
  final bool submitted;

  ClothesState({
    required this.model,
    this.submitted = false,
  });

  ClothesState copyWith({
    ClothesModel? model,
    bool? submitted,
  }) {
    return ClothesState(
      model: model ?? this.model,
      submitted: submitted ?? this.submitted,
    );
  }
}
