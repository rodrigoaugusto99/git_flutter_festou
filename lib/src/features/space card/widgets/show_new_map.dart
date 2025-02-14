import 'package:flutter/material.dart';
import 'package:festou/src/features/space%20card/widgets/show_map.dart';
import 'package:festou/src/models/space_model.dart';

class ShowNewMap extends StatefulWidget {
  final SpaceModel space;
  const ShowNewMap({
    super.key,
    required this.space,
  });

  @override
  State<ShowNewMap> createState() => _ShowNewMapState();
}

class _ShowNewMapState extends State<ShowNewMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.close),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: ShowMap(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        space: widget.space,
        scrollGesturesEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        x: false,
      ),
    );
  }
}
