import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/my_sliver_list_normal.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_vm.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/surrounding%20spaces/surrounding_spaces_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/surrounding%20spaces/surrounding_spaces_vm.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_card_info.dart';
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
  CameraPosition? currentCameraPosition;
  bool canRefresh = false;

  LatLngBounds rioDeJaneiroBounds = LatLngBounds(
    southwest: const LatLng(-23.336615865621933, -43.460534401237965),
    northeast: const LatLng(-22.472079364142523, -42.89604641497135),
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
                initialCameraPosition: currentCameraPosition ??
                    const CameraPosition(
                      target: LatLng(-22.9122, -43.2303),
                      zoom: 10,
                    ),
                onCameraMove: (CameraPosition cameraPosition) async {
                  currentCameraPosition = cameraPosition;
                  // Esta função será chamada sempre que a câmera do mapa for movida

                  // Agora você pode usar a visibleRegion para obter os limites visíveis do mapa
                  // e realizar qualquer lógica adicional, como chamar o Firestore para recuperar espaços dentro desses limites.
                },
                circles: {
                  ...data.spaces.map((space) {
                    return Circle(
                      circleId: CircleId(space.spaceId.toString()),
                      center: LatLng(space.latitude, space.longitude),
                      radius: 1000,
                      strokeWidth: 0,
                      fillColor: Colors.red.withOpacity(0.3),
                      strokeColor: Colors.red,
                    );
                  }),
                },
                markers: data.spaces.map((space) {
                  return Marker(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewCardInfo(space: space),
                      ),
                    ),
                    markerId: MarkerId(space.spaceId),
                    position: LatLng(space.latitude, space.longitude),
                    // Adicione outras informações sobre o espaço, se necessário
                    // infoWindow: InfoWindow(title: space.name, snippet: space.description),
                  );
                }).toSet(),
              ),
              Positioned(
                top: 16.0,
                right: 16.0,
                child: FloatingActionButton(
                  onPressed: () async {
                    LatLngBounds visibleRegion =
                        await mapController!.getVisibleRegion();
                    /*eu estava em duvida em sincronizar o initialCameraPosition
                        com o rioDeJaneiroBounds (visao inicial p carregar o espaços).
                        então, printei o valor da regiao visivel logo quando entra no mapa,
                        ou seja, quando é o initialCameraPosition.*/
                    log('Visible Region: $visibleRegion');

                    setState(() {
                      rioDeJaneiroBounds = visibleRegion;
                    });
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
