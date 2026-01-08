abstract class WashEvent {}

class SelectDetergent extends WashEvent {
  final String detergent;
  SelectDetergent(this.detergent);
}

class ToggleSoftener extends WashEvent {
  final bool value;
  ToggleSoftener(this.value);
}

class SelectTemperature extends WashEvent {
  final String temp;
  SelectTemperature(this.temp);
}

class UpdateFragranceNote extends WashEvent {
  final String note;
  UpdateFragranceNote(this.note);
}
