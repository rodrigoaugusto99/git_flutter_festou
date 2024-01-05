import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/my_sliver_list_normal.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_vm.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/surrounding%20spaces/surrounding_spaces_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/surrounding%20spaces/surrounding_spaces_vm.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SurroundingSpacesPage extends ConsumerStatefulWidget {
  const SurroundingSpacesPage({super.key});

  @override
  ConsumerState<SurroundingSpacesPage> createState() =>
      _SurroundingSpacesPageState();
}

//TODO: spaces by surrounding area

class _SurroundingSpacesPageState extends ConsumerState<SurroundingSpacesPage> {
  GoogleMapController? mapController;
  bool isReloading = false;

  Future<void> reloadSpaces(LatLngBounds bounds) async {
    setState(() {
      isReloading = true;
    });

    try {
      // Lógica para recarregar espaços com base na região visível (bounds)
      await reloadSpaces(bounds);
    } finally {
      setState(() {
        isReloading = false;
      });
    }
  }

  Future<LatLngBounds?> getVisibleRegion(GoogleMapController controller) async {
    if (controller == null) return null;

    try {
      // Obtenha as coordenadas da região visível do mapa
      LatLngBounds bounds = await controller.getVisibleRegion();
      return bounds;
    } catch (e) {
      log('Erro ao obter a região visível: $e');
      return null;
    }
  }

  LatLngBounds rioDeJaneiroBounds = LatLngBounds(
    southwest: const LatLng(-23.0838, -43.7957),
    northeast: const LatLng(-22.7469, -43.0962),
  );

  @override
  Widget build(BuildContext context) {
    final allSpaces =
        ref.watch(surroundingSpacesVmProvider(rioDeJaneiroBounds));

    final message = ref.watch(allSpacesVmProvider.notifier).errorMessage;

    Future.delayed(Duration.zero, () {
      if (message.toString() != '') {
        Messages.showError(message, context);
      }
    });

    return Scaffold(
      body: allSpaces.when(
        data: (SurroundingSpacesState data) {
          return Stack(
            children: [
              GoogleMap(
                onMapCreated: (controller) {
                  mapController = controller;
                },
                initialCameraPosition: const CameraPosition(
                  target: LatLng(-22.9122, -43.2303),
                  zoom: 10,
                ),
                onCameraMove: (CameraPosition cameraPosition) async {
                  // Esta função será chamada sempre que a câmera do mapa for movida
                  LatLngBounds visibleRegion =
                      await mapController!.getVisibleRegion();
                  log('Visible Region: $visibleRegion');

                  rioDeJaneiroBounds = visibleRegion;

                  // Agora você pode usar a visibleRegion para obter os limites visíveis do mapa
                  // e realizar qualquer lógica adicional, como chamar o Firestore para recuperar espaços dentro desses limites.
                },
                /*circles: {
                Circle(
                  circleId: const CircleId('userRadius'),
                  center: maracanaCoordinates,
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
              }).toSet(),*/
              ),
              Positioned(
                top: 16.0,
                right: 16.0,
                child: FloatingActionButton(
                  onPressed: isReloading
                      ? null
                      : () async {
                          LatLngBounds visibleRegion =
                              await mapController!.getVisibleRegion();
                          await reloadSpaces(visibleRegion);
                        },
                  child: const Icon(Icons.refresh),
                ),
              ),
            ],
          );
        },
        error: (Object error, StackTrace stackTrace) {
          return const Stack(children: [
            Center(child: Text('Inserir imagem melhor papai')),
            Center(child: Icon(Icons.error)),
          ]);
        },
        loading: () {
          return const Stack(children: [
            Center(child: Text('Inserir carregamento Personalizado papai')),
            Center(child: CircularProgressIndicator()),
          ]);
        },
      ),
    );
  }
}
