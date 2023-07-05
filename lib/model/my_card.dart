import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyCard {
  List<String> images;
  String nome;
  String lugar;
  String numero;
  LatLng location;

  MyCard({
    required this.images,
    required this.nome,
    required this.lugar,
    required this.numero,
    required this.location,
  });
}
