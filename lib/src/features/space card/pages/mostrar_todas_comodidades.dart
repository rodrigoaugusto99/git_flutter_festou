import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class MostrarTodasComodidades extends StatefulWidget {
  final SpaceWithImages space;
  const MostrarTodasComodidades({
    super.key,
    required this.space,
  });

  @override
  State<MostrarTodasComodidades> createState() =>
      _MostrarTodasComodidadesState();
}

class _MostrarTodasComodidadesState extends State<MostrarTodasComodidades> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'O que esse lugar oferece',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.space.space.selectedServices
                  .map((service) => Column(
                        children: [
                          Text(service),
                          const SizedBox(height: 10),
                          const Divider(thickness: 0.4, color: Colors.grey),
                          const SizedBox(height: 10),
                        ],
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
