import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/pages/screens/rating_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_view/photo_view.dart';
import '../model/card_comment.dart';
import '../model/my_card.dart';

/*----------------BOTÕES DO CARD------------*/

//não precisam de int index pois cada card já significa filteredCards[index] ou myCards[index]

class CardFunctions {
  static void showMap(MyCard card, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Localização no Mapa'),
          content: SizedBox(
            height: 200.0,
            //cada card terá um botao com esse widget
            child: GoogleMap(
              /*vai abrir inicialmente na posição cadastrada do card
                                            (propriedade location(LatLng) do card atual)*/
              initialCameraPosition: CameraPosition(
                target: card.location,
                zoom: 15.0,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('location'),
                  position: card.location,
                ),
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  static void showPhotos(MyCard card, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Todas as fotos'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width * 0.9,
            //cada card terá um botao com esse widget
            child: Swiper(
              itemCount: card.allImages.length,
              itemBuilder: (BuildContext context, int itemIndex) {
                return Image.file(
                  card.allImages[itemIndex],
                  fit: BoxFit.cover,
                );
              },
              // Defina a fração da largura ocupada por cada item do carrossel
              viewportFraction: 0.9,
              // Defina o fator de escala para os itens adjacentes ao item central
              scale: 0.95,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  static void showPhotos2(MyCard card, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Todas as fotos'),
          content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width * 0.9,
              //cada card terá um botao com esse widget
              child: GridView.builder(
                itemCount: card.allImages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Duas imagens por linha
                ),
                itemBuilder: (BuildContext context, int itemIndex) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoView(
                              initialScale: PhotoViewComputedScale.covered,
                              imageProvider:
                                  FileImage(card.allImages[itemIndex])),
                        ),
                      );
                    },
                    child: Image.file(
                      card.allImages[itemIndex],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              )),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  static void showDetails(MyCard card, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mais detalhes',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Espaço',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(card.selectedSpaceType)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Disponibilidade',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(card.selectedAvailability)
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 10,
                thickness: 2,
              ),
              const Text(
                'Servicos disponiveis:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Loop forEach para mostrar cada serviço em um Text
              // Obs: Pode usar ListView.builder caso haja muitos itens
              // para melhorar a rolagem.
              ...card.servicos.map((servico) => Text(servico)),
              const Divider(
                height: 10,
                thickness: 2,
              ),
              const Text(
                'Reservas:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...card.reservas.map((reserva) => Text(reserva.toString())),
              /*Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: card.reservas.map((reserva) {
                  return Text(reserva.toString());
                }).toList(),
              ),*/
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  static void showComments(MyCard card, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Comentarios'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: card.feedbacks.map((feedback) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('rating:'),
                      Text(
                        feedback.rating.toString(), // Título em negrito
                      ),
                      const SizedBox(height: 5), // Espaçamento
                      const Text('content:'),
                      Text(
                        feedback.content.toString(), // Comentário
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  static void openRatingDialog(
      MyCard card, BuildContext context, VoidCallback setStateCallback) {
    int rating = 0;
    TextEditingController feedbackController = TextEditingController();
    TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deixe seu feedback'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Titulo',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: feedbackController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Digite aqui seu feedback...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setStateCallback();
                        rating = index + 1;
                      },
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                    );
                  }),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: card.comentarios.map((comment) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.titulo, // Título em negrito
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const Text(
                            'Usuário', // Usuário em cinza
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 5), // Espaçamento
                          Text(
                            comment.conteudo, // Comentário
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                String conteudo = feedbackController.text;
                String titulo = titleController.text;

                Comentario comentario =
                    Comentario(titulo: titulo, conteudo: conteudo);
                card.comentarios.add(comentario);
                // Você pode usar o valor de _rating e feedbackText como necessário
                // para enviar o feedback e a classificação para onde desejar.
                Navigator.of(context).pop();
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  static void openRatingDialog2(MyCard card, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: RatingView(card: card),
        );
      },
    );
  }
}
