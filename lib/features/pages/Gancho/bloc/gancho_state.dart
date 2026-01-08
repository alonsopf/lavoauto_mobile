class GanchoState {
  final String selectedOption;

  const GanchoState({this.selectedOption = "Gancho nuevo"});

  GanchoState copyWith({String? selectedOption}) {
    return GanchoState(
      selectedOption: selectedOption ?? this.selectedOption,
    );
  }
}
