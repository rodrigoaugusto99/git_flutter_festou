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

void main() => runApp(const CustomLoadingIndicator());

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SizedBox(
          height: 40,
          child: LoadingIndicator(
            indicatorType: Indicator.lineSpinFadeLoader,
            colors: _kDefaultRainbowColors,
            strokeWidth: 4.0,
            pathBackgroundColor: Colors.black45,
          ),
        ),
      ),
    );
  }
}
