class AirportBookingState {
  final bool isToAirport;
  final int selectedCarIndex;

  AirportBookingState({
    required this.isToAirport,
    required this.selectedCarIndex,
  });

  AirportBookingState copyWith({
    bool? isToAirport,
    int? selectedCarIndex,
  }) {
    return AirportBookingState(
      isToAirport: isToAirport ?? this.isToAirport,
      selectedCarIndex: selectedCarIndex ?? this.selectedCarIndex,
    );
  }
}
