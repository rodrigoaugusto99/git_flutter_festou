import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/home/widgets/space_card.dart';

class FavoriteSpacesPage extends StatelessWidget {
  const FavoriteSpacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Meus Espaços Favoritos"),
      ),
      body: ListView.builder(
        itemCount: 5, // Número de containers a serem exibidos
        itemBuilder: (context, index) {
          return const SpaceCard();
        },
      ),
    );
  }
}
