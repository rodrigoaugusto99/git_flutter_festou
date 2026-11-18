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
  List<BannerModel> banners = [];
  int currentIndex = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getBanners();
  }

  Future<void> getBanners() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('banners').get();

      var bannerUrls = <BannerModel>[];
      if (querySnapshot.docs.isNotEmpty) {
        bannerUrls = querySnapshot.docs
            .map((doc) => BannerModel.fromDocument(doc))
            .toList();
      }

      banners = bannerUrls..sort((a, b) => a.index.compareTo(b.index));
      if (mounted) {
        setState(() => loading = false);
      }
    } catch (error) {
      log('Error getting gifts: $error');
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF0EAF8),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
    }

    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          itemBuilder: (context, index, realIndex) {
            final banner = banners[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    banner.photoUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 16 / 9,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            enlargeFactor: 0.12,
            enableInfiniteScroll: banners.length > 1,
            onPageChanged: (index, reason) {
              setState(() => currentIndex = index);
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (index) {
            final selected = currentIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: selected ? 18 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                color: selected
                    ? const Color(0xFF7C3AED)
                    : const Color(0xFFD5CBE4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
