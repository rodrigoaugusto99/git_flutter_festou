import 'package:flutter/material.dart';

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
