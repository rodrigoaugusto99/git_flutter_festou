import 'package:flutter/material.dart';
import 'dart:io';

enum InformacoesPessoaisStateStatus { initial, success, error }

class InformacoesPessoaisState {
  final InformacoesPessoaisStateStatus status;
  final String? errorMessage;
  final List<File> imageFiles;
  final File image1;
  final File image2;

  InformacoesPessoaisState(
      {required this.status,
      required this.imageFiles,
      required this.image1,
      required this.image2,
      this.errorMessage});

  InformacoesPessoaisState.initial()
      : this(
          image1: File(''),
          image2: File(''),
          status: InformacoesPessoaisStateStatus.initial,
          imageFiles: <File>[],
        );

  InformacoesPessoaisState copyWith(
      {InformacoesPessoaisStateStatus? status,
      ValueGetter<String?>? errorMessage,
      List<File>? imageFiles,
      File? image1,
      File? image2}) {
    return InformacoesPessoaisState(
        status: status ?? this.status,
        errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
        imageFiles: imageFiles ?? this.imageFiles,
        image1: image1 ?? this.image1,
        image2: image2 ?? this.image2);
  }
}
