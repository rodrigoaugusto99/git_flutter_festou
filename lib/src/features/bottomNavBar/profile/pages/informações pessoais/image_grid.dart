import 'package:flutter/material.dart';

class ImageGrid extends StatelessWidget {
  final List<String> imagesUrl;

  const ImageGrid({super.key, required this.imagesUrl});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Image.network(
            imagesUrl[index],
            fit: BoxFit.cover,
          );
        },
        childCount: imagesUrl.length,
      ),
    );
  }
}
