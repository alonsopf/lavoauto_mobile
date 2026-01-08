abstract class GanchoEvent {}

class SelectGanchoOption extends GanchoEvent {
  final String option;
  SelectGanchoOption(this.option);
}
