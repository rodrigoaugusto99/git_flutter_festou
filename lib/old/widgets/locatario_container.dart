// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class LocatarioContainer extends StatefulWidget {
  double height;
  List<Widget>? items;
  LocatarioContainer({
    Key? key,
    required this.height,
    required this.items,
  }) : super(key: key);

  @override
  State<LocatarioContainer> createState() => _LocatarioContainerState();
}

class _LocatarioContainerState extends State<LocatarioContainer> {
  int currentPos = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 10),
          autoPlayAnimationDuration: const Duration(seconds: 2),
          autoPlayCurve: Curves.decelerate,
          height: widget.height,
          viewportFraction: 1.0,
          enableInfiniteScroll: true,
          onPageChanged: (index, _) {
            setState(() {
              currentPos = index;
            });
          },
        ),
        items: widget.items,
      ),
    );
  }
}
