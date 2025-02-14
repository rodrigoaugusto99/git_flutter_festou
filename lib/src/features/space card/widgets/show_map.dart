import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:festou/src/features/space%20card/widgets/dialog_map.dart';
import 'package:festou/src/models/space_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowMap extends StatefulWidget {
  final bool zoomControlsEnabled;
  final bool scrollGesturesEnabled;
  final bool zoomGesturesEnabled;
  final double height;
  final double width;
  final SpaceModel space;
  final bool x;
  const ShowMap({
    super.key,
    required this.space,
    required this.scrollGesturesEnabled,
    required this.zoomControlsEnabled,
    required this.zoomGesturesEnabled,
    required this.height,
    required this.width,
    required this.x,
  });

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
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0), // Arredonda o Container
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: selectedLocation ?? const LatLng(0, 0),
                zoom: 13.5,
              ),
              onCameraMove: (CameraPosition position) {
                // Imprime o valor do zoom no terminal sempre que ele mudar
              },
              circles: selectedLocation != null
                  ? {
                      Circle(
                        circleId: const CircleId('locationCircle'),
                        center: selectedLocation!,
                        radius: 1000, // Raio em metros
                        strokeWidth: 0,
                        fillColor: Colors.red.withOpacity(
                            0.3), // Cor de preenchimento vermelho claro
                        strokeColor: Colors.red,
                      ),
                    }
                  : <Circle>{},
              zoomControlsEnabled: widget.zoomControlsEnabled,
              scrollGesturesEnabled: widget.scrollGesturesEnabled,
              zoomGesturesEnabled: widget.zoomGesturesEnabled,
            ),
            Visibility(
              visible: widget.x,
              child: const Positioned(
                left: 25,
                right: 25,
                top: 20,
                child: DialogMap(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
