class WashState {
  final String selectedDetergent;
  final bool softener;
  final String temperature;
  final String fragranceNote;

  const WashState({
    this.selectedDetergent = "Detergente normal",
    this.softener = false,
    this.temperature = "Fría",
    this.fragranceNote = "",
  });

  WashState copyWith({
    String? selectedDetergent,
    bool? softener,
    String? temperature,
    String? fragranceNote,
  }) {
    return WashState(
      selectedDetergent: selectedDetergent ?? this.selectedDetergent,
      softener: softener ?? this.softener,
      temperature: temperature ?? this.temperature,
      fragranceNote: fragranceNote ?? this.fragranceNote,
    );
  }
}
