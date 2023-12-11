import 'package:flutter/material.dart';
import 'dart:io';

enum InformacoesPessoaisStateStatus { initial, success, error }

class InformacoesPessoaisState {
  final InformacoesPessoaisStateStatus status;
  final String? errorMessage;
  final List<File> imageFiles;

  InformacoesPessoaisState({
    required this.status,
    required this.imageFiles,
    this.errorMessage,
  });

  InformacoesPessoaisState.initial()
      : this(
          status: InformacoesPessoaisStateStatus.initial,
          imageFiles: <File>[],
        );
  InformacoesPessoaisState copyWith(
      {InformacoesPessoaisStateStatus? status,
      ValueGetter<String?>? errorMessage,
      List<File>? imageFiles}) {
    return InformacoesPessoaisState(
        status: status ?? this.status,
        errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
        imageFiles: imageFiles ?? this.imageFiles);
  }
}
