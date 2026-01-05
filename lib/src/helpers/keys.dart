import 'package:flutter/material.dart';

class Keys {
  //widgets
  static Key kTextFormField = const Key("kTextFormField");
  static Key kButtonWiget = const Key("kTextFormField");
  static Key kChipWidget = const Key("kChipWidget");

  static Key kSignaturePaint = const Key("kSignaturePaint");
  static Key kSignaturePaper = const Key("kSignaturePaper");
  static Key kSignatureConfirmButton = const Key("kSignatureConfirmButton");
  //static Key kChipDayWidget = const Key("kChipDayWidget");
  static Key kSelectDayIndex(int index) {
    return Key("select_day$index");
  }

  //loginI
  static Key kLoginViewEmail = const Key("kLoginViewEmail");
  static Key kLoginViewPassword = const Key("kLoginViewPassword");
  static Key kLoginViewButton = const Key("kLoginViewButton");

  //home
  static Key kHomeViewProfile = const Key("kHomeViewProfile");
  static Key kHomeScaffold = const Key("kHomeScaffold");
  static Key kSpaceTypeCasamento = const Key("kSpaceTypeCasamento");

  //space card
  static Key kSpaceCard = const Key("kSpaceCard");
  static Key kAlugarButton = const Key("kAlugarButton");

  //calendar page
  static Key kCalendarDay(int day) {
    return Key("kCalendarDay_$day");
  }

  static Key kCheckInTime(int hour) {
    return Key("kCheckInTime_$hour");
  }

  static Key kCheckOutTime(int hour) {
    return Key("kCheckOutTime_$hour");
  }

  static Key kContinuarButton = const Key("kContinuarButton");

  //resumo reserva page
  static Key kTrocarMetodoPagamento = const Key("kTrocarMetodoPagamento");
  static Key kLerAssinarContrato = const Key("kLerAssinarContrato");
  static Key kReservarButton = const Key("kReservarButton");

  //pagamentos page
  static Key kPixButton = const Key("kPixButton");

  //contrato page
  static Key kAssinarContratoButton = const Key("kAssinarContratoButton");

  //contrato assinado page
  static Key kContinuarReservaButton = const Key("kContinuarReservaButton");

  //perfil
  static Key kProfileViewLocador = const Key("kProfileViewLocador");

  //dialog
  static Key kDialogConfirm = const Key("kDialogConfirm");

  //locador form
  static Key kLocadorFormEnviarButton = const Key("kLocadorFormEnviarButton");

  //locador view
  static Key kLocadorViewRegisterSpace = const Key("kLocadorViewRegisterSpace");

  //primeira tela
  static Key kFirstScreenButton = const Key("kFirstScreenButton");

  //segunda tela
  static Key kSecondScreenButton = const Key("kSecondScreenButton");

  //terceira tela
  static Key k3creenButton = const Key("k3creenButton");

  //quarta tela
  static Key k4ScreenButton = const Key("k4ScreenButton");

  //quinta tela
  static Key k5creenButton = const Key("k5creenButton");

  //sexta tela
  static Key k6ScreenButton = const Key("k6ScreenButton");

  //setima tela
  static Key k7ScreenButton = const Key("k7ScreenButton");

  //oitava tela
  static Key k8creenButton = const Key("k8creenButton");

  //nona tela
  static Key k9ScreenButton = const Key("k9ScreenButton");

  //decima tela
  static Key k10ScreenButton = const Key("k10ScreenButton");
}
