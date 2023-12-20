import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

enum FilterAndOrderStateStatus { initial, success, error }

class FilterAndOrderState {
  final FilterAndOrderStateStatus status;
  final List<String> selectedTypes;
  final List<String> selectedServices;
  final List<String> availableDays;
  //final List<String> selectedNotes;
  final List<SpaceModel> filteredSpaces;
  final String? errorMessage;

  FilterAndOrderState.initial()
      : this(
          status: FilterAndOrderStateStatus.initial,
          selectedTypes: <String>[],
          selectedServices: <String>[],
          availableDays: <String>[],
          filteredSpaces: <SpaceModel>[],
        );

  FilterAndOrderState(
      {required this.status,
      required this.selectedTypes,
      required this.selectedServices,
      required this.availableDays,
      required this.filteredSpaces,
      this.errorMessage});

  FilterAndOrderState copyWith(
      {FilterAndOrderStateStatus? status,
      List<String>? selectedTypes,
      List<String>? selectedServices,
      List<String>? availableDays,
      List<SpaceModel>? filteredSpaces,
      ValueGetter<String?>? errorMessage}) {
    return FilterAndOrderState(
      status: status ?? this.status,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      selectedServices: selectedServices ?? this.selectedServices,
      availableDays: availableDays ?? this.availableDays,
      filteredSpaces: filteredSpaces ?? this.filteredSpaces,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
