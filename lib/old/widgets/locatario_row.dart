// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class LocatarioRow extends StatelessWidget {
  double height;
  VoidCallback onPressedNext;
  VoidCallback onPressedBack;
  List<Widget>? items;
  CarouselController? carouselController;
  LocatarioRow({
    Key? key,
    required this.height,
    required this.onPressedNext,
    required this.onPressedBack,
    required this.items,
    required this.carouselController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onPressedBack,
        ),
        Expanded(
          child: SizedBox(
            height: height,
            child: CarouselSlider(
              carouselController: carouselController,
              options: CarouselOptions(
                height: height,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                scrollDirection: Axis.horizontal,
              ),
              items: items,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: onPressedNext,
        ),
      ],
    );
  }
}
