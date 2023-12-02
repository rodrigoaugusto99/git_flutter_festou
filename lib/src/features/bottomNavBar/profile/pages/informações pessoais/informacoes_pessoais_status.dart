import 'package:flutter/material.dart';

enum InformacoesPessoaisStateStatus { initial, success, error }

class InformacoesPessoaisState {
  final InformacoesPessoaisStateStatus status;
  final String? errorMessage;

  InformacoesPessoaisState({required this.status, this.errorMessage});

  InformacoesPessoaisState.initial()
      : this(
          status: InformacoesPessoaisStateStatus.initial,
        );

  InformacoesPessoaisState copyWith(
      {InformacoesPessoaisStateStatus? status,
      ValueGetter<String?>? errorMessage}) {
    return InformacoesPessoaisState(
        status: status ?? this.status,
        errorMessage:
            errorMessage != null ? errorMessage() : this.errorMessage);
  }
}
