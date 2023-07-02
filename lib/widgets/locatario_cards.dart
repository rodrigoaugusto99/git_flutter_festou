// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class LocatarioCards extends StatelessWidget {
  int itemCount;
  double height;
  double carouselHeight;
  List<Widget> items;

  LocatarioCards({
    Key? key,
    required this.itemCount,
    required this.height,
    required this.carouselHeight,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(30.0)),
            child: Container(
              color: Colors.deepPurple,
              height: height,
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: carouselHeight,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: items,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
