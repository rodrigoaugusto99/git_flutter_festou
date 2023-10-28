import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/features/home/widgets/my_squaretile.dart';
import 'package:git_flutter_festou/src/services/auth_services.dart';

class Feed extends StatelessWidget {
  final String text;
  final String text2;
  final VoidCallback onTap;
  const Feed(
      {super.key,
      required this.text,
      required this.text2,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                thickness: 0.5,
                color: Colors.grey[400],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                TextConstants.orContinueWith,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            Expanded(
              child: Divider(
                thickness: 0.5,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        //google + apple sign in buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //google button
            SquareTile(
              onTap: () => AuthService().signInWithGoogle(),
              imagePath: 'lib/assets/images/google.png',
            ),
            const SizedBox(width: 25),
            //apple button
            SquareTile(
              onTap: () {},
              imagePath: 'lib/assets/images/apple.png',
            )
          ],
        ),
        const SizedBox(height: 20),

        //not a member? register now
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: onTap,
              child: Text(
                text2,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
