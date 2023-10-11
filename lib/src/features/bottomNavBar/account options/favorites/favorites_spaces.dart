import 'package:flutter/material.dart';

class FavoriteSpacesPage extends StatelessWidget {
  const FavoriteSpacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Espaços Favoritos"),
      ),
      body: ListView.builder(
        itemCount: 5, // Número de containers a serem exibidos
        itemBuilder: (context, index) {
          return Container(
            height: 200,
            color: Colors.grey,
            margin: const EdgeInsets.all(
                10), // Margem para espaçamento entre os containers
          );
        },
      ),
    );
  }
}
