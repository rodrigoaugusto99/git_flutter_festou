import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/google_maps.dart';

class LocationListPage extends StatefulWidget {
  const LocationListPage({Key? key}) : super(key: key);

  @override
  _LocationListPageState createState() => _LocationListPageState();
}

class _LocationListPageState extends State<LocationListPage> {
  List<LatLng> locations = [];
  List<String> locationNames = [];

  @override
  void initState() {
    super.initState();
    fillLocationNames();
  }

  Future<void> fillLocationNames() async {
    for (var location in locations) {
      String locationName = await getLocationName(location);
      setState(() {
        locationNames.add(locationName);
      });
    }
  }

  Future<String> getLocationName(LatLng coordinates) async {
    String address = await getAddressFromCoordinates(
      coordinates.latitude,
      coordinates.longitude,
    );
    return address;
  }

  Future<String>? selectedLocationName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Localizações'),
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder<String>(
            future: getLocationName(locations[index]),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              } else {
                String locationName = snapshot.data ?? '';
                return ListTile(
                  title: Text('Localização ${index + 1}'),
                  subtitle: Text(locationName),
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              LatLng selectedLocation = const LatLng(-23.5505, -46.6333);
              String selectedLocationName = '';

              return AlertDialog(
                title: const Text('Adicionar Localização'),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 200.0,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: selectedLocation,
                                zoom: 15.0,
                              ),
                              onTap: (LatLng location) async {
                                selectedLocation = location;
                                selectedLocationName =
                                    await getLocationName(selectedLocation);
                                setState(() {});
                              },
                            ),
                          ),
                          Text(
                            'Endereço selecionado: $selectedLocation\n$selectedLocationName',
                          ),
                          const SizedBox(height: 16.0),
                          const Text('ou'),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Endereço',
                            ),
                            onFieldSubmitted: (String value) async {
                              if (value.isNotEmpty) {
                                LatLng coordinates =
                                    await getCoordinatesFromAddress(value);
                                setState(() {
                                  selectedLocation = coordinates;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                actions: [
                  ElevatedButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Adicionar'),
                    onPressed: () {
                      setState(() {
                        locations.add(selectedLocation);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
