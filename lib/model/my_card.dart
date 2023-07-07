import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyCard {
  List<String> defaultImages;
  List<File> images;
  List<File> allImages;

  String nome;
  String lugar;
  String numero;
  LatLng location;
  String selectedLocationName;

  MyCard({
    required this.images,
    required this.allImages,
    required this.nome,
    required this.lugar,
    required this.numero,
    required this.location,
    this.selectedLocationName = '',
    required this.defaultImages,
  });
}
