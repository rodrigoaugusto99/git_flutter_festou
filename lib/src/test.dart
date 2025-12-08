import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

void gerarSchema(String collectionName) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final snapshot = await firestore.collection(collectionName).limit(10).get();

  final camposTipos = <String, Set<String>>{};
  final subcollectionsEstrutura = <String, Map<String, String>>{};

  for (var doc in snapshot.docs) {
    final data = doc.data();
    data.forEach((chave, valor) {
      final tipo = _inferirTipoEstrutura(valor);
      camposTipos.putIfAbsent(chave, () => <String>{}).add(tipo);
    });

    // Buscar estrutura das subcollections (apenas uma vez por nome)
    final subcollectionsDoc =
        await _buscarEstruturaSubcollections(doc.reference);
    subcollectionsDoc.forEach((subcollectionName, campos) {
      if (!subcollectionsEstrutura.containsKey(subcollectionName)) {
        subcollectionsEstrutura[subcollectionName] = campos;
      }
    });
  }

  final schema = {
    collectionName[0].toUpperCase() + collectionName.substring(1): {
      "type": "object",
      "properties": {
        for (var campo in camposTipos.entries)
          campo.key: {
            "type": campo.value.length == 1
                ? campo.value.first
                : campo.value.toList()
          }
      },
      "required": camposTipos.keys.toList(),
      if (subcollectionsEstrutura.isNotEmpty)
        "subcollections": {
          for (var entry in subcollectionsEstrutura.entries)
            entry.key: {
              "type": "object",
              "properties": {
                for (var campo in entry.value.entries)
                  campo.key: {"type": campo.value}
              }
            }
        }
    }
  };

  final schemaJson = const JsonEncoder.withIndent('  ').convert(schema);
  log(schemaJson);
}

Future<Map<String, Map<String, String>>> _buscarEstruturaSubcollections(
    DocumentReference docRef) async {
  final estrutura = <String, Map<String, String>>{};
  final possiveisSubcollections = ['cards'];
  for (final subcollectionName in possiveisSubcollections) {
    try {
      final subcollectionRef = docRef.collection(subcollectionName);
      final snapshot = await subcollectionRef.limit(10).get();
      if (snapshot.docs.isNotEmpty) {
        final campos = <String, String>{};
        for (var doc in snapshot.docs) {
          final data = doc.data();
          data.forEach((chave, valor) {
            final tipo = _inferirTipoEstrutura(valor);
            campos[chave] = tipo;
          });
        }
        estrutura[subcollectionName] = campos;
      }
    } catch (_) {}
  }
  return estrutura;
}

String _inferirTipoEstrutura(dynamic valor) {
  if (valor is String) {
    if (RegExp(r"^[\\w\\.-]+@[\\w\\.-]+\\.\\w+").hasMatch(valor)) {
      return "string";
    }
    if (RegExp(r"^\\d{3}\\.\\d{3}\\.\\d{3}\\-\\d{2}").hasMatch(valor)) {
      return "string";
    }
    if (DateTime.tryParse(valor) != null) {
      return "string";
    }
    return "string";
  } else if (valor is bool) {
    return "boolean";
  } else if (valor is int) {
    return "integer";
  } else if (valor is double) {
    return "number";
  } else if (valor is Timestamp) {
    return "timestamp";
  } else if (valor is Map) {
    return "object";
  } else if (valor is List) {
    return "array";
  } else {
    return "null";
  }
}
