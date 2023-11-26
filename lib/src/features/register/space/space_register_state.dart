import 'package:flutter/material.dart';
import 'dart:io';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

enum SpaceRegisterStateStatus { initial, success, error, invalidForm }

class SpaceRegisterState {
  final SpaceRegisterStateStatus status;
  final List<String> selectedTypes;
  final List<String> selectedServices;
  final List<String> availableDays;
  final SpaceWithImages temporarySpace;
  //final AddressModel addressModel;
  //final Map<String, List<int>> availableHours;
  final List<File> imageFiles;
  final String? errorMessage;

  SpaceRegisterState.initial()
      : this(
            status: SpaceRegisterStateStatus.initial,
            selectedTypes: <String>[],
            selectedServices: <String>[],
            availableDays: <String>[],
            imageFiles: <File>[],
            temporarySpace: SpaceWithImages(
              SpaceModel(
                  false,
                  'spaceId',
                  'userId',
                  'titulo',
                  'cep',
                  'logradouro',
                  'numero',
                  'bairro',
                  'cidade',
                  <String>[],
                  <String>[],
                  'averageRating',
                  'numComments',
                  'locadorName',
                  'descricao',
                  'city'),
              <String>[],
            )
            /*addressModel: AddressModel(
            cep: '',
            logradouro: '',
            numero: '',
            bairro: '',
            cidade: '',
          ),*/
            );

  SpaceRegisterState(
      {required this.status,
      required this.selectedTypes,
      required this.selectedServices,
      required this.availableDays,
      required this.temporarySpace,
      required this.imageFiles,
      this.errorMessage});

  SpaceRegisterState copyWith(
      {SpaceRegisterStateStatus? status,
      List<String>? selectedTypes,
      List<String>? selectedServices,
      List<String>? availableDays,
      SpaceWithImages? temporarySpace,
      List<File>? imageFiles,
      ValueGetter<String?>? errorMessage}) {
    return SpaceRegisterState(
        status: status ?? this.status,
        selectedTypes: selectedTypes ?? this.selectedTypes,
        selectedServices: selectedServices ?? this.selectedServices,
        availableDays: availableDays ?? this.availableDays,
        temporarySpace: temporarySpace ?? this.temporarySpace,
        imageFiles: imageFiles ?? this.imageFiles,
        errorMessage:
            errorMessage != null ? errorMessage() : this.errorMessage);
  }
}
