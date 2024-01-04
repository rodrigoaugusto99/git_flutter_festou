import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/dialog_map.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AllSpacesTest extends StatefulWidget {
  final bool zoomControlsEnabled;
  final bool scrollGesturesEnabled;
  final bool zoomGesturesEnabled;
  final double height;
  final double width;
  final List<SpaceModel> spaces;

  final bool x;
  const AllSpacesTest({
    super.key,
    required this.spaces,
    required this.scrollGesturesEnabled,
    required this.zoomControlsEnabled,
    required this.zoomGesturesEnabled,
    required this.height,
    required this.width,
    required this.x,
  });

  @override
  State<AllSpacesTest> createState() => _AllSpacesTestState();
}

class _AllSpacesTestState extends State<AllSpacesTest> {
  GoogleMapController? mapController;
  List<LatLng> spaceLocations = []; // Alterada para ser uma variável nula
  CameraPosition? initialCameraPosition; // Adicione esta linha

  @override
  void initState() {
    super.initState();
    loadLocalInfo();
  }

  Future<void> loadLocalInfo() async {
    try {
      for (var space in widget.spaces) {
        // Lógica para obter coordenadas do espaço
        try {
          // Construa o endereço completo concatenando as partes do endereço
          String fullAddress = '';
          fullAddress += '${space.logradouro}, ';
          fullAddress += '${space.bairro}, ';
          fullAddress += space.cidade;
          fullAddress += '${space.numero}, ';

          // Obter coordenadas geográficas a partir do endereço completo
          try {
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

              try {
                List<Location> locations = await locationFromAddress(
                  // Construa o endereço completo a partir dos dados do espaço
                  "${space.logradouro}, ${space.bairro}, ${space.cidade}, ${space.numero}",
                );

                if (locations.isNotEmpty) {
                  LatLng coordinates = LatLng(
                    locations.first.latitude,
                    locations.first.longitude,
                  );
// Definir a variável selectedLocation
                  setState(() {
                    spaceLocations.add(coordinates);
                  });
                } else {
                  print(
                      'Nenhum resultado encontrado para o endereço do espaço: ${space.logradouro}');
                }
              } catch (e) {
                print('Erro ao obter coordenadas do espaço: $e');
              }
            } else {
              log('Nenhum resultado encontrado para o endereço: $fullAddress');
            }
          } on Exception {
            log('erro ao encontrar esse endereço do loop');
          }
        } catch (e) {
          // Lidar com erros, como endereço inválido ou problemas de geocodificação
          log('Erro ao obter coordenadas a partir do endereço: $e');
        }
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
                // Ajuste a câmera do mapa para a média das coordenadas dos espaços
                if (spaceLocations.isNotEmpty) {
                  final (bounds, center) = boundsFromLatLngList(spaceLocations);
                  mapController?.animateCamera(
                    CameraUpdate.newLatLng(center),
                  );
                }
              },
              initialCameraPosition: initialCameraPosition ??
                  const CameraPosition(
                    target: LatLng(0, 0),
                    zoom: 13.5,
                  ),
              onCameraMove: (CameraPosition position) {
                // Imprime o valor do zoom no terminal sempre que ele mudar
              },
              circles: spaceLocations.map((location) {
                return Circle(
                  circleId: CircleId(location.toString()),
                  center: location,
                  radius: 1000,
                  strokeWidth: 0,
                  fillColor: Colors.red.withOpacity(0.3),
                  strokeColor: Colors.red,
                );
              }).toSet(),
              markers: spaceLocations.map((location) {
                return Marker(
                  markerId: MarkerId(location.toString()),
                  position: location,
                  // Adicione outras informações sobre o espaço, se necessário
                  // infoWindow: InfoWindow(title: space.name, snippet: space.description),
                );
              }).toSet(),
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

  // Função para calcular os limites do mapa com base em uma lista de coordenadas
  (LatLngBounds, LatLng) boundsFromLatLngList(List<LatLng> list) {
    double? minLat, maxLat, minLng, maxLng;

    for (LatLng latLng in list) {
      if (minLat == null || latLng.latitude < minLat) minLat = latLng.latitude;
      if (maxLat == null || latLng.latitude > maxLat) maxLat = latLng.latitude;
      if (minLng == null || latLng.longitude < minLng) {
        minLng = latLng.longitude;
      }
      if (maxLng == null || latLng.longitude > maxLng) {
        maxLng = latLng.longitude;
      }
    }

    // Calcula o centro manualmente
    double centerLat = (minLat! + maxLat!) / 2;
    double centerLng = (minLng! + maxLng!) / 2;

    LatLng center = LatLng(centerLat, centerLng);

    // Cria a instância de LatLngBounds e a retorna
    return (
      LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      ),
      center
    );
  }
}
