import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festou/src/models/banner_model.dart';
import 'package:flutter/material.dart';

class CuponsEPromocoes extends StatefulWidget {
  const CuponsEPromocoes({super.key});

  @override
  State<CuponsEPromocoes> createState() => _CuponsEPromocoesState();
}

class _CuponsEPromocoesState extends State<CuponsEPromocoes> {
  @override
  void initState() {
    super.initState();
    getBanners();
  }

  List<BannerModel> banners = [];
  Future<void> getBanners() async {
    try {
      // Recuperar IDs de gifts usados pelo usuário
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('banners').get();

      List<BannerModel> bannerUrls = [];
      if (querySnapshot.docs.isNotEmpty) {
        bannerUrls = querySnapshot.docs
            .map((doc) => BannerModel.fromDocument(doc))
            .toList();
      }

      banners = bannerUrls;
      banners.sort((a, b) => a.index.compareTo(b.index));
      setState(() {});
    } catch (error) {
      log('Error getting gifts: $error');
      return;
    }
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    // List<String> images = [
    //   'lib/assets/images/cupom_50_dinheiro.png',
    //   'lib/assets/images/cupom_10OFF.png',
    //   'lib/assets/images/cupom_30OFF.png'
    // ];
    return Column(
      children: [
        CarouselSlider(
          items: banners
              .map((banner) => Image.network(
                    banner.photoUrl,
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
            children: banners.map((ban) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == ban.index
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
