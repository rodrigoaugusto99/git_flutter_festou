import 'package:flutter/material.dart';

class SpaceModelTest {
  final String name;
  final String email;
  final String cep;
  final String endereco;
  final String numero;
  final String bairro;
  final String cidade;
  final List<String> selectedTypes;
  final List<String> selectedServices;
  final List<String> availableDays;
  final List<Feedback> feedbacks;

  SpaceModelTest({
    required this.name,
    required this.email,
    required this.cep,
    required this.endereco,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.selectedTypes,
    required this.selectedServices,
    required this.availableDays,
    required this.feedbacks,
  });
}
