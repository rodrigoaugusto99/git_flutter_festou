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

  const AllSpacesTest({
    super.key,
    required this.spaces,
    required this.scrollGesturesEnabled,
    required this.zoomControlsEnabled,
    required this.zoomGesturesEnabled,
    required this.height,
    required this.width,
  });

  @override
  State<AllSpacesTest> createState() => _AllSpacesTestState();
}

class _AllSpacesTestState extends State<AllSpacesTest> {
  GoogleMapController? mapController;
  List<LatLng> spaceLocations = []; // Alterada para ser uma variável nula
  LatLng? userLocation; // Adicionado para armazenar a localização do usuário
  double radiusInMeters = 200000; // Valor padrão para o raio
  LatLng maracanaCoordinates = const LatLng(-22.9122, -43.2303);

  @override
  void initState() {
    super.initState();
    //?requestLocationPermission();
    loadLocalInfo();
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

  Future<List<LatLng>> loadLocalInfo() async {
    List<LatLng> spaceLocations = [];

    try {
      for (var space in widget.spaces) {
        String fullAddress =
            '${space.logradouro}, ${space.bairro}, ${space.cidade}, ${space.numero}';

        List<Location> locations = await locationFromAddress(fullAddress);

        if (locations.isNotEmpty) {
          LatLng coordinates = LatLng(
            locations.first.latitude,
            locations.first.longitude,
          );

          double distance = Geolocator.distanceBetween(
            //?userLocation.latitude,
            //?userLocation.longitude,
            maracanaCoordinates.latitude,
            maracanaCoordinates.longitude,
            coordinates.latitude,
            coordinates.longitude,
          );

          if (distance <= radiusInMeters) {
            spaceLocations.add(coordinates);
          } else {
            log('O espaço ${space.logradouro} está fora do raio do usuário.');
          }
        } else {
          log('Nenhum resultado encontrado para o endereço do espaço: $fullAddress');
        }
      }
    } catch (e) {
      log('Erro ao processar espaços: $e');
    }

    return spaceLocations;
  }

  Future<void> _changeRadiusDialog() async {
    // Controlador do TextEditingController para obter o valor digitado pelo usuário
    TextEditingController radiusController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mudar o Raio'),
          content: TextField(
            controller: radiusController,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(labelText: 'Digite o raio em metros'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Verifique se o valor digitado é válido e atualize o raio
                double? newRadius = double.tryParse(radiusController.text);
                if (newRadius != null && newRadius > 0) {
                  radiusInMeters = newRadius;
                  Navigator.of(context).pop();
                } else {
                  // Exiba uma mensagem de erro ou faça algo apropriado se o valor não for válido
                  // Aqui, estou apenas exibindo um log
                  log('Por favor, insira um valor válido para o raio.');
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LatLng>>(
      future: loadLocalInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar os dados'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum espaço disponível'));
        }

        List<LatLng> spaceLocations = snapshot.data!;

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
          child: Stack(
            children: [
              GoogleMap(
                /*onMapCreated: (controller) {
              mapController = controller;

              // Ajuste a câmera do mapa para a localização atual do usuário
              if (userLocation != null) {
                mapController?.animateCamera(
                  CameraUpdate.newLatLng(userLocation!),
                );
              }
            },*/
                initialCameraPosition: CameraPosition(
                  target: maracanaCoordinates, //?? const LatLng(0, 0),
                  zoom: 10,
                ),
                circles: {
                  Circle(
                    circleId: const CircleId('userRadius'),
                    center: maracanaCoordinates, //?? const LatLng(0, 0),
                    radius: radiusInMeters,
                    strokeWidth: 1,
                    strokeColor: Colors.blue,
                    fillColor: Colors.blue.withOpacity(0.3),
                  ),
                  ...spaceLocations.map((location) {
                    return Circle(
                      circleId: CircleId(location.toString()),
                      center: location,
                      radius: 1000,
                      strokeWidth: 0,
                      fillColor: Colors.red.withOpacity(0.3),
                      strokeColor: Colors.red,
                    );
                  }),
                },
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
              Positioned(
                child: ElevatedButton(
                  onPressed: _changeRadiusDialog,
                  child: const Text('Mude o raio'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
