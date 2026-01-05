import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget appCachedNetWorkImage({
  String? imageUrl,
  double? height,
  double? width,
  BoxFit? fit,
  bool isRounded = false,
  double? radius,
}) {
  // if (imageUrl == null) {
  //   return Image.asset(
  //     'lib/assets/icons/iii.png',
  //     height: height,
  //     width: width,
  //   );
  // }

  return ClipRRect(
    borderRadius: isRounded
        ? BorderRadius.circular(radius ?? 8)
        : BorderRadius.circular(0),
    child: CachedNetworkImage(
      height: height,
      width: width,
      fit: fit ?? (imageUrl != '' ? BoxFit.cover : null),
      // imageUrl:
      //     'https://static.wixstatic.com/media/c9e8aa_96e7516efd444f7693337d7283fa316f~mv2.png/v1/fill/w_447,h_117,al_c,lg_1,q_85,enc_auto/logo-TOPPAYY-bco.png',
      imageUrl: imageUrl != null && imageUrl != ''
          ? imageUrl
          : 'https://static.wixstatic.com/media/c9e8aa_96e7516efd444f7693337d7283fa316f~mv2.png/v1/fill/w_447,h_117,al_c,lg_1,q_85,enc_auto/logo-TOPPAYY-bco.png',
      placeholder: (context, url) {
        return Skeletonizer(
          enabled: true,
          child: Skeleton.leaf(
            child: Container(
              color: Colors.red,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) => Skeletonizer(
        enabled: true,
        child: Skeleton.leaf(
          child: Container(
            color: Colors.red,
          ),
        ),
      ),
    ),
  );
}
