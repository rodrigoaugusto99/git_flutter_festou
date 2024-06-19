import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ApplicatioAnimation extends StatelessWidget {
  const ApplicatioAnimation({super.key});
  @override
  Widget build(BuildContext context) {
    final y = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: y * 0.8),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Desenvolvido por',
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Monospace',
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 1000),
              isRepeatingAnimation: true,
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
            const SizedBox(height: 20),
            const AnimatedGradientText(
              text: 'APPLICATIO',
              fontSize: 20.0,
            ),
            const Text(
              '.com.br',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedGradientText extends StatefulWidget {
  final String text;
  final double fontSize;

  const AnimatedGradientText(
      {super.key, required this.text, required this.fontSize});

  @override
  _AnimatedGradientTextState createState() => _AnimatedGradientTextState();
}

class _AnimatedGradientTextState extends State<AnimatedGradientText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.indigo,
                Colors.purple,
                Color.fromARGB(255, 84, 0, 219),
              ],
              stops: [
                _animation.value - 0.8,
                _animation.value - 0.6,
                _animation.value - 0.4,
                _animation.value - 0.2,
                _animation.value,
                _animation.value + 0.2,
                _animation.value + 0.4,
                _animation.value + 0.8,
              ],
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'Monospace',
              letterSpacing: 10,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
