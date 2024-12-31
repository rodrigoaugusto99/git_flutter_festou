import 'package:flutter/material.dart';

class Keys {
  //widgets
  static Key kTextFormField = const Key("kTextFormField");
  static Key kButtonWiget = const Key("kTextFormField");
  static Key kChipWidget = const Key("kChipWidget");
  //static Key kChipDayWidget = const Key("kChipDayWidget");
  static Key kSelectDayIndex(int index) {
    return Key("select_day$index");
  }

  //login
  static Key kLoginViewEmail = const Key("kLoginViewEmail");
  static Key kLoginViewPassword = const Key("kLoginViewPassword");
  static Key kLoginViewButton = const Key("kLoginViewButton");

  //home
  static Key kHomeViewProfile = const Key("kHomeViewProfile");

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
