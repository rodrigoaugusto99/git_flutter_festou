import 'package:flutter/material.dart';
import 'dart:io';

import 'package:git_flutter_festou/src/models/space_model.dart';

enum NewSpaceRegisterStateStatus { initial, success, error, invalidForm }

class NewSpaceRegisterState {
  final NewSpaceRegisterStateStatus status;
  final List<String> selectedTypes;
  final List<String> selectedServices;
  final String titulo;
  final String descricao;
  final String cep;
  final String logradouro;
  final String numero;
  final String bairro;
  final String cidade;
  final String estado;
  final String preco;

  final List<File> imageFiles;
  final List<File> videoFiles;
  final String? errorMessage;

  final Days? days;

  NewSpaceRegisterState.initial()
      : this(
          status: NewSpaceRegisterStateStatus.initial,
          selectedTypes: <String>[],
          selectedServices: <String>[],
          titulo: '',
          descricao: '',
          imageFiles: <File>[],
          videoFiles: <File>[],
          cep: '',
          logradouro: '',
          numero: '',
          bairro: '',
          cidade: '',
          preco: '',
          estado: '',
          days: null,
        );

  NewSpaceRegisterState({
    required this.status,
    required this.selectedTypes,
    required this.selectedServices,
    required this.titulo,
    required this.descricao,
    required this.cep,
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.imageFiles,
    required this.preco,
    required this.days,
    required this.estado,
    required this.videoFiles,
    this.errorMessage,
  });

  NewSpaceRegisterState copyWith(
      {NewSpaceRegisterStateStatus? status,
      List<String>? selectedTypes,
      List<String>? selectedServices,
      String? titulo,
      String? descricao,
      String? cep,
      String? logradouro,
      String? numero,
      String? bairro,
      String? cidade,
      String? estado,
      String? preco,
      Days? days,
      List<File>? imageFiles,
      List<File>? videoFiles,
      ValueGetter<String?>? errorMessage}) {
    return NewSpaceRegisterState(
      status: status ?? this.status,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      selectedServices: selectedServices ?? this.selectedServices,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      cep: cep ?? this.cep,
      logradouro: logradouro ?? this.logradouro,
      numero: numero ?? this.numero,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      imageFiles: imageFiles ?? this.imageFiles,
      videoFiles: videoFiles ?? this.videoFiles,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      preco: preco ?? this.preco,
      estado: estado ?? this.estado,
      days: days ?? this.days,
    );
  }
}
