import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

enum ReservationRegisterState2Status { loaded, error }

class ReservationRegisterState2 {
  final ReservationRegisterState2Status status;
  final String range;
  final String? errorMessage;

  ReservationRegisterState2(
      {required this.status, required this.range, this.errorMessage});

  ReservationRegisterState2 copyWith(
      {ReservationRegisterState2Status? status,
      String? range,
      ValueGetter<String?>? errorMessage}) {
    return ReservationRegisterState2(
        status: status ?? this.status,
        range: range ?? this.range,
        errorMessage:
            errorMessage != null ? errorMessage() : this.errorMessage);
  }
}
