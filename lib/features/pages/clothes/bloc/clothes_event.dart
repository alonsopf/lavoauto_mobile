abstract class ClothesEvent {}

class ChangeQuantity extends ClothesEvent {
  final String quantity;
  ChangeQuantity(this.quantity);
}

class ToggleClothesType extends ClothesEvent {
  final String key;
  final bool value;
  ToggleClothesType(this.key, this.value);
}

class ChangeNote extends ClothesEvent {
  final String note;
  ChangeNote(this.note);
}

class SubmitClothes extends ClothesEvent {}
