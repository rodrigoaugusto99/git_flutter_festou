import 'package:flutter/material.dart';

Widget decContainer({
  double? radius,
  double? height,
  double? width,
  double? leftPadding,
  double? topPadding,
  double? rightPadding,
  double? bottomPadding,
  double? borderWidth,
  Color? color,
  Color? foregroundColor,
  Color? borderColor,
  double? allPadding,
  Widget? child,
  Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      foregroundDecoration: BoxDecoration(color: foregroundColor),
      padding: EdgeInsets.only(
        left: leftPadding ?? allPadding ?? 0,
        top: topPadding ?? allPadding ?? 0,
        right: rightPadding ?? allPadding ?? 0,
        bottom: bottomPadding ?? allPadding ?? 0,
      ),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: borderWidth != null && borderColor != null
            ? Border.all(
                width: borderWidth,
                color: borderColor,
              )
            : null,
        borderRadius: radius == null ? null : BorderRadius.circular(radius),
      ),
      child: child,
    ),
  );
}
