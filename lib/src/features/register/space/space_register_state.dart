import 'package:flutter/material.dart';
import 'dart:io';

enum SpaceRegisterStateStatus { initial, success, error, invalidForm }

class SpaceRegisterState {
  final SpaceRegisterStateStatus status;
  final List<String> selectedTypes;
  final List<String> selectedServices;
  final List<String> availableDays;
  //final Map<String, List<int>> availableHours;
  final List<File> imageFiles;
  final String? errorMessage;

  SpaceRegisterState.initial()
      : this(
          status: SpaceRegisterStateStatus.initial,
          selectedTypes: <String>[],
          selectedServices: <String>[],
          availableDays: <String>[],
          //availableHours: <String, List<int>>{},
          imageFiles: <File>[],
        );

  SpaceRegisterState(
      {required this.status,
      required this.selectedTypes,
      required this.selectedServices,
      required this.availableDays,
      //required this.availableHours,
      required this.imageFiles,
      this.errorMessage});

  SpaceRegisterState copyWith(
      {SpaceRegisterStateStatus? status,
      List<String>? selectedTypes,
      List<String>? selectedServices,
      List<String>? availableDays,
      //Map<String, List<int>>? availableHours,
      List<File>? imageFiles,
      ValueGetter<String?>? errorMessage}) {
    return SpaceRegisterState(
        status: status ?? this.status,
        selectedTypes: selectedTypes ?? this.selectedTypes,
        selectedServices: selectedServices ?? this.selectedServices,
        availableDays: availableDays ?? this.availableDays,
        //availableHours: availableHours ?? this.availableHours,
        imageFiles: imageFiles ?? this.imageFiles,
        errorMessage:
            errorMessage != null ? errorMessage() : this.errorMessage);
  }
}
