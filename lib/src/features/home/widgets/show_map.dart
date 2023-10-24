import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowMap extends StatefulWidget {
  final SpaceModel space;
  const ShowMap({super.key, required this.space});

  @override
  State<ShowMap> createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  GoogleMapController? mapController;
  LatLng? selectedLocation; // Alterada para ser uma variável nula

  @override
  void initState() {
    super.initState();
    loadLocalInfo(
      cidade: widget.space.cidade,
      bairro: widget.space.bairro,
      logradouro: widget.space.logradouro,
      numero: widget.space.numero,
    );
  }

  Future<void> loadLocalInfo({
    String? cidade,
    String? bairro,
    String? logradouro,
    String? numero,
  }) async {
    try {
      if (cidade == null &&
          bairro == null &&
          logradouro == null &&
          numero == null) {
        log('Nenhum dado de endereço fornecido.');
        return;
      }

      // Construa o endereço completo concatenando as partes do endereço
      String fullAddress = '';
      if (logradouro != null) {
        fullAddress += '$logradouro, ';
      }
      if (bairro != null) {
        fullAddress += '$bairro, ';
      }
      if (cidade != null) {
        fullAddress += cidade;
      }
      if (numero != null) {
        fullAddress += '$numero, ';
      }

      // Obter coordenadas geográficas a partir do endereço completo
      List<Location> locations = await locationFromAddress(fullAddress);

      if (locations.isNotEmpty) {
        LatLng coordinates = LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );

        // Atualizar a posição da câmera do GoogleMap
        mapController?.animateCamera(
          CameraUpdate.newLatLng(coordinates),
        );

        // Definir a variável selectedLocation
        setState(() {
          selectedLocation = coordinates;
        });
      } else {
        log('Nenhum resultado encontrado para o endereço: $fullAddress');
      }
    } catch (e) {
      // Lidar com erros, como endereço inválido ou problemas de geocodificação
      log('Erro ao obter coordenadas a partir do endereço: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Marker marker = Marker(
      markerId: const MarkerId('location'),
      position: selectedLocation ?? const LatLng(0, 0),
    );

    Set<Marker> markers = {marker};

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          const Text(
            'Localização',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: GoogleMap(
                onMapCreated: (controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: selectedLocation ?? const LatLng(0, 0),
                  zoom: 15.0,
                ),
                markers: selectedLocation != null ? markers : <Marker>{},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
