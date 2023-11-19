import 'package:flutter/material.dart';
import 'dart:io';

import 'package:git_flutter_festou/src/models/address_model.dart';

enum NewSpaceRegisterStateStatus { initial, success, error }

class NewSpaceRegisterStateBase {
  final NewSpaceRegisterStateStatus status;
  final String? errorMessage;

  NewSpaceRegisterStateBase({
    required this.status,
    this.errorMessage,
  });
}

class NewSpaceRegisterStateWithSelectedTypes extends NewSpaceRegisterStateBase {
  final List<String> selectedTypes;

  NewSpaceRegisterStateWithSelectedTypes({
    required NewSpaceRegisterStateStatus status,
    required this.selectedTypes,
    String? errorMessage,
  }) : super(status: status, errorMessage: errorMessage);
}

class NewSpaceRegisterStateWithSelectedServices
    extends NewSpaceRegisterStateBase {
  final List<String> selectedServices;

  NewSpaceRegisterStateWithSelectedServices({
    required NewSpaceRegisterStateStatus status,
    required this.selectedServices,
    String? errorMessage,
  }) : super(status: status, errorMessage: errorMessage);
}

class NewSpaceRegisterStateWithImageFiles extends NewSpaceRegisterStateBase {
  final List<File> imageFiles;

  NewSpaceRegisterStateWithImageFiles({
    required NewSpaceRegisterStateStatus status,
    required this.imageFiles,
    String? errorMessage,
  }) : super(status: status, errorMessage: errorMessage);
}

class NewSpaceRegisterStateWithAddressModel extends NewSpaceRegisterStateBase {
  final AddressModel addressModel;

  NewSpaceRegisterStateWithAddressModel({
    required NewSpaceRegisterStateStatus status,
    required this.addressModel,
    String? errorMessage,
  }) : super(status: status, errorMessage: errorMessage);
}

class NewSpaceRegisterState {
  final NewSpaceRegisterStateStatus status;
  final NewSpaceRegisterStateWithSelectedTypes selectedTypesState;
  final NewSpaceRegisterStateWithSelectedServices selectedServicesState;
  final NewSpaceRegisterStateWithImageFiles imageFilesState;
  final NewSpaceRegisterStateBase availableDaysState;
  final NewSpaceRegisterStateWithAddressModel addressModelState;
  final String? errorMessage;

  NewSpaceRegisterState(
      {required this.status,
      required this.selectedTypesState,
      required this.selectedServicesState,
      required this.imageFilesState,
      required this.availableDaysState,
      required this.addressModelState,
      this.errorMessage});

  factory NewSpaceRegisterState.initial() {
    return NewSpaceRegisterState(
      selectedTypesState: NewSpaceRegisterStateWithSelectedTypes(
        status: NewSpaceRegisterStateStatus.initial,
        selectedTypes: [],
      ),
      selectedServicesState: NewSpaceRegisterStateWithSelectedServices(
        status: NewSpaceRegisterStateStatus.initial,
        selectedServices: [],
      ),
      imageFilesState: NewSpaceRegisterStateWithImageFiles(
        status: NewSpaceRegisterStateStatus.initial,
        imageFiles: [],
      ),
      availableDaysState: NewSpaceRegisterStateBase(
        status: NewSpaceRegisterStateStatus.initial,
      ),
      addressModelState: NewSpaceRegisterStateWithAddressModel(
        status: NewSpaceRegisterStateStatus.initial,
        addressModel: AddressModel(
          cep: '',
          logradouro: '',
          numero: '',
          bairro: '',
          cidade: '',
        ),
      ),
      status: NewSpaceRegisterStateStatus.initial,
    );
  }
  NewSpaceRegisterState copyWith(
      {NewSpaceRegisterStateStatus? status,
      NewSpaceRegisterStateWithSelectedTypes? selectedTypesState,
      NewSpaceRegisterStateWithSelectedServices? selectedServicesState,
      NewSpaceRegisterStateWithImageFiles? imageFilesState,
      NewSpaceRegisterStateBase? availableDaysState,
      NewSpaceRegisterStateWithAddressModel? addressModelState,
      ValueGetter<String?>? errorMessage}) {
    return NewSpaceRegisterState(
        status: status ?? this.status,
        selectedTypesState: selectedTypesState ?? this.selectedTypesState,
        selectedServicesState:
            selectedServicesState ?? this.selectedServicesState,
        imageFilesState: imageFilesState ?? this.imageFilesState,
        availableDaysState: availableDaysState ?? this.availableDaysState,
        addressModelState: addressModelState ?? this.addressModelState,
        errorMessage:
            errorMessage != null ? errorMessage() : this.errorMessage);
  }
}
