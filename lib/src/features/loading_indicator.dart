import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

const List<Color> _kDefaultRainbowColors = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 40,
        width: 40, // Define largura para evitar problemas de layout
        child: LoadingIndicator(
          indicatorType: Indicator.lineSpinFadeLoader,
          colors: _kDefaultRainbowColors,
          strokeWidth: 4.0,
          pathBackgroundColor: Colors.black45,
        ),
      ),
    );
  }
}
