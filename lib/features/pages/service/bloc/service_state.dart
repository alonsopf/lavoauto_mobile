class ServiceState {
  final String selectedService;
  final String selectedDate;

  ServiceState({
    this.selectedService = "Lavado",
    this.selectedDate = "Selecciona la fecha y hora",
  });

  ServiceState copyWith({
    String? selectedService,
    String? selectedDate,
  }) {
    return ServiceState(
      selectedService: selectedService ?? this.selectedService,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
