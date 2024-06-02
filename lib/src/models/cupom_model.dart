// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class CupomModel {
  String codigo;
  Timestamp validade;
  int valorDesconto;
  CupomModel({
    required this.codigo,
    required this.validade,
    required this.valorDesconto,
  });
}
