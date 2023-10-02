enum SpaceRegisterStateStatus { initial, success, error }

class SpaceRegisterState {
  final SpaceRegisterStateStatus status;
  final List<String> selectedTypes;
  final List<String> selectedServices;
  final List<String> availableDays;
  final Map<String, List<int>> availableHours;

  SpaceRegisterState.initial()
      : this(
          status: SpaceRegisterStateStatus.initial,
          selectedTypes: <String>[],
          selectedServices: <String>[],
          availableDays: <String>[],
          availableHours: <String, List<int>>{},
        );

  SpaceRegisterState(
      {required this.status,
      required this.selectedTypes,
      required this.selectedServices,
      required this.availableDays,
      required this.availableHours,
      required});

  SpaceRegisterState copyWith(
      {SpaceRegisterStateStatus? status,
      List<String>? selectedTypes,
      List<String>? selectedServices,
      List<String>? availableDays,
      Map<String, List<int>>? availableHours}) {
    return SpaceRegisterState(
        status: status ?? this.status,
        selectedTypes: selectedTypes ?? this.selectedTypes,
        selectedServices: selectedServices ?? this.selectedServices,
        availableDays: availableDays ?? this.availableDays,
        availableHours: availableHours ?? this.availableHours);
  }
}
