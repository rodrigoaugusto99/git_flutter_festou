import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/dialog_map.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

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
  LatLng? userLocation; // Adicionado para armazenar a localização do usuário

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  Future<void> requestLocationPermission() async {
    if (await Permission.location.request().isGranted) {
      Position position = await Geolocator.getCurrentPosition();

      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });
      // A permissão foi concedida, agora você pode carregar as informações locais
      loadLocalInfo();
    } else {
      // O usuário recusou a permissão, você pode lidar com isso de acordo com seus requisitos
      log('Permissão de localização negada pelo usuário.');
    }
  }

  Future<void> loadLocalInfo() async {
    try {
      // Obter a localização atual do usuário

      double radiusInMeters = 50000;

      for (var space in widget.spaces) {
        try {
          String fullAddress =
              '${space.logradouro}, ${space.bairro}, ${space.cidade}, ${space.numero}';

          List<Location> locations = await locationFromAddress(fullAddress);

          if (locations.isNotEmpty) {
            LatLng coordinates = LatLng(
              locations.first.latitude,
              locations.first.longitude,
            );

            double distance = Geolocator.distanceBetween(
              userLocation!.latitude,
              userLocation!.longitude,
              coordinates.latitude,
              coordinates.longitude,
            );

            if (distance <= radiusInMeters) {
              setState(() {
                spaceLocations.add(coordinates);
              });
            } else {
              log('O espaço ${space.logradouro} está fora do raio do usuário.');
            }
          } else {
            log('Nenhum resultado encontrado para o endereço do espaço: $fullAddress');
          }
        } catch (e) {
          log('Erro ao processar o espaço: $e');
        }
      }
    } catch (e) {
      log('Erro ao processar espaços: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userLocation == null) {
      // Se o userLocation ainda não foi atribuído, retorne um widget de carregamento ou algo semelhante
      return const Center(child: CircularProgressIndicator());
    }
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

                // Ajuste a câmera do mapa para a localização atual do usuário
                if (userLocation != null) {
                  mapController?.animateCamera(
                    CameraUpdate.newLatLng(userLocation!),
                  );
                }
              },
              initialCameraPosition: CameraPosition(
                target: userLocation ?? const LatLng(0, 0),
                zoom: 10,
              ),
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
}
