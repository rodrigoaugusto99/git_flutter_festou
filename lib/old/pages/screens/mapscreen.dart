import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  String cep = "Digite o CEP aqui"; // O CEP que você deseja pesquisar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa com base no CEP"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0), // Posição inicial padrão
              zoom: 15.0, // Nível de zoom inicial
            ),
            onMapCreated: _onMapCreated,
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: "Digite o CEP",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  cep = value;
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _buscarCoordenadasPorEndereco(cep);
        },
        child: const Icon(Icons.search),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _buscarCoordenadasPorEndereco(String endereco) async {
    try {
      List<Location> locations = await locationFromAddress(endereco);
      if (locations.isNotEmpty) {
        Location location = locations.first;

        // Recupere o Placemark associado às coordenadas
        List<Placemark> placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;

          print(
              "Endereço: ${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}");
          // Outras informações do placemark, como cidade, estado, país, etc., estão disponíveis aqui.

          mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(location.latitude, location.longitude),
              15.0,
            ),
          );
        } else {
          print("Nenhum placemark encontrado para as coordenadas.");
        }
      } else {
        print("Nenhuma localização encontrada para o endereço.");
      }
    } catch (e) {
      print("Erro ao buscar coordenadas por endereço: $e");
    }
  }
}
