import 'package:flutter/material.dart';
import 'package:git_flutter_festou/pages/rating_view.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Container(
        child: Column(
          children: [
            const Text('feedback'),
            TextButton.icon(
              onPressed: (() => openRatingDialog(context)),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Colors.blue.withOpacity(0.1),
                ),
              ),
              icon: const Icon(Icons.star),
              label: const Text('Rate us!'),
            )
          ],
        ),
      ),
    );
  }

  openRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          child: RatingView(),
        );
      },
    );
  }
}
