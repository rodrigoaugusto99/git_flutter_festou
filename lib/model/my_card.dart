import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'card_reserve.dart';

class MyCard {
  List<String> defaultImages;
  List<File> images;
  List<File> allImages;

  String nome;
  String lugar;
  String numero;
  String email;
  LatLng location;
  String selectedLocationName;
  String selectedSpaceType; // Tipo de espaço selecionado
  List<String> servicos; // Serviços oferecidos pelo espaço
  String descricao; // Descrição do espaço
  String selectedAvailability;
  List<Reserva> reservas;
  List<DateTime> markedDates;
  List<String> comments;

  MyCard({
    required this.defaultImages,
    required this.images,
    required this.allImages,
    required this.nome,
    required this.lugar,
    required this.numero,
    required this.email,
    required this.location,
    this.selectedLocationName = '',
    required this.selectedSpaceType, // Incluindo o atributo selectedSpaceType
    required this.servicos, // Incluindo o atributo servicos
    required this.descricao, // Incluindo o atributo descricao
    required this.selectedAvailability,
    required this.reservas,
    required this.markedDates,
    required this.comments,
  });
}
