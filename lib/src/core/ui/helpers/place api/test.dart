import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: QuickSearchScreen(),
    );
  }
}

class QuickSearchScreen extends StatefulWidget {
  const QuickSearchScreen({super.key});

  @override
  _QuickSearchScreenState createState() => _QuickSearchScreenState();
}

class _QuickSearchScreenState extends State<QuickSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Location> _locations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Enter an address',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String query = _searchController.text;
                List<Location> locations = await getLocationSuggestions(query);
                setState(() {
                  _locations = locations;
                });
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _locations.length,
                itemBuilder: (context, index) {
                  Location location = _locations[index];
                  return FutureBuilder(
                    future: getAddressFromCoordinates(
                        location.latitude, location.longitude),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(
                          title: Text('Loading...'),
                        );
                      } else if (snapshot.hasError) {
                        return const ListTile(
                          title: Text('Error loading address'),
                        );
                      } else {
                        String address = snapshot.data as String;
                        return ListTile(
                          title: Text(address),
                          subtitle: Text(
                            'Lat: ${location.latitude}, Long: ${location.longitude}',
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Location>> getLocationSuggestions(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      return locations;
    } catch (e) {
      log("Error getting location suggestions: $e");
      return [];
    }
  }

  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark firstPlacemark = placemarks.first;
      return "${firstPlacemark.street}, ${firstPlacemark.locality}, ${firstPlacemark.administrativeArea}";
    } catch (e) {
      return 'N/A';
    }
  }
}
