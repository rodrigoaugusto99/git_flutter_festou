// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

enum FilterAndOrderStateStatus { initial, success, error }

class FilterAndOrderState {
  final FilterAndOrderStateStatus status;
  final List<String> selectedTypes;
  final List<String> selectedServices;
  final List<String> availableDays;
  //final List<String> selectedNotes;
  final List<SpaceWithImages> filteredSpaces;

  FilterAndOrderState.initial()
      : this(
          status: FilterAndOrderStateStatus.initial,
          selectedTypes: <String>[],
          selectedServices: <String>[],
          availableDays: <String>[],
          filteredSpaces: <SpaceWithImages>[],
        );

  FilterAndOrderState({
    required this.status,
    required this.selectedTypes,
    required this.selectedServices,
    required this.availableDays,
    required this.filteredSpaces,
  });

  FilterAndOrderState copyWith({
    FilterAndOrderStateStatus? status,
    List<String>? selectedTypes,
    List<String>? selectedServices,
    List<String>? availableDays,
    List<SpaceWithImages>? filteredSpaces,
  }) {
    return FilterAndOrderState(
      status: status ?? this.status,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      selectedServices: selectedServices ?? this.selectedServices,
      availableDays: availableDays ?? this.availableDays,
      filteredSpaces: filteredSpaces ?? this.filteredSpaces,
    );
  }
}
