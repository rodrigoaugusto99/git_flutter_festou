import 'package:flutter/material.dart';

class FestouNavGlobalKey {
  static FestouNavGlobalKey? _instance;

  final navKey = GlobalKey<NavigatorState>();
  FestouNavGlobalKey._();
  static FestouNavGlobalKey get instance =>
      _instance ??= FestouNavGlobalKey._();
}
