import 'package:flutter/material.dart';

class SearchButton extends StatefulWidget {
  const SearchButton({super.key});

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  @override
  Widget build(BuildContext context) {
    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: x * 0.03, vertical: y * 0.03),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            Navigator.of(context).pushNamed('/caminhoDaPagina'); // TODO: Adicionar o caminho da página de pesquisa aqui (precisa criá-la)
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: x * 0.02, vertical: y * 0.01),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.purple[300]),
                const SizedBox(width: 10.0),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.blueGrey[500]),
                    children: const <TextSpan>[
                      TextSpan(text: 'Buscar no '),
                      TextSpan(text: 'Festou', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}