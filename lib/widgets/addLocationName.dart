import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../old/helpers/google_maps.dart';

class AddLocationDialog extends StatefulWidget {
  final LatLng? initialLocation;

  const AddLocationDialog({Key? key, this.initialLocation}) : super(key: key);

  @override
  _AddLocationDialogState createState() => _AddLocationDialogState();
}

class _AddLocationDialogState extends State<AddLocationDialog> {
  LatLng? selectedLocation;
  String? selectedLocationName;

  Future<String> getLocationName(LatLng coordinates) async {
    String address = await getAddressFromCoordinates(
      coordinates.latitude,
      coordinates.longitude,
    );
    return address;
  }

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.initialLocation;
    updateSelectedLocationName();
  }

  Future<void> updateSelectedLocationName() async {
    selectedLocationName = await getLocationName(selectedLocation!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Localização'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200.0,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: selectedLocation!,
                  zoom: 15.0,
                ),
                onTap: (LatLng location) async {
                  selectedLocation = location;
                  await updateSelectedLocationName();
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
                  LatLng coordinates = await getCoordinatesFromAddress(value);
                  setState(() {
                    selectedLocation = coordinates;
                  });
                  await updateSelectedLocationName();
                }
              },
            ),
          ],
        ),
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
            Navigator.of(context).pop(selectedLocation);
          },
        ),
      ],
    );
  }
}
