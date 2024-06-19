import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CuponsEPromocoes extends StatefulWidget {
  const CuponsEPromocoes({super.key});

  @override
  State<CuponsEPromocoes> createState() => _CuponsEPromocoesState();
}

class _CuponsEPromocoesState extends State<CuponsEPromocoes> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<String> images = [
      'lib/assets/images/Cupom de 50dddd.png',
      'lib/assets/images/Banner cashbackasasasa.png',
      'lib/assets/images/Cupom 30%qrfxx (1).png'
    ];
    return Column(
      children: [
        CarouselSlider(
          items: images
              .map((image) => Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ))
              .toList(),
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            enableInfiniteScroll: true,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.map((img) {
              int index = images.indexOf(img);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == index
                      ? const Color(0xff9747FF)
                      : Colors.grey.shade500,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
