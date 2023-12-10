import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

enum ReservationRegisterStateStatus { initial, success, error }

class ReservationRegisterState {
  final ReservationRegisterStateStatus status;
  final String range;
  final String? errorMessage;

  ReservationRegisterState.initial()
      : this(
          status: ReservationRegisterStateStatus.initial,
          range: '',
        );

  ReservationRegisterState(
      {required this.status, required this.range, this.errorMessage});

  ReservationRegisterState copyWith(
      {ReservationRegisterStateStatus? status,
      String? range,
      ValueGetter<String?>? errorMessage}) {
    return ReservationRegisterState(
        status: status ?? this.status,
        range: range ?? this.range,
        errorMessage:
            errorMessage != null ? errorMessage() : this.errorMessage);
  }
}
