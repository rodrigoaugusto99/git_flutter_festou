import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/home/widgets/more_details.dart';
import 'package:git_flutter_festou/src/features/home/widgets/rating_view.dart';
import 'package:git_flutter_festou/src/models/space/space_model_test.dart';

class CardInfos extends StatefulWidget {
  final SpaceModelTest space;
  const CardInfos({
    super.key,
    required this.space,
  });

  @override
  State<CardInfos> createState() => _CardInfosState();
}

class _CardInfosState extends State<CardInfos> {
  void openRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          child: RatingView(),
        );
      },
    );
  }

  List<Icon> buildStarIcons(int rating) {
    return List.generate(
      rating,
      (index) => const Icon(
        Icons.star,
        color: Colors.yellow,
        size: 24.0,
      ),
    );
  }

  void showComments(SpaceModelTest space) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Comentários'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: space.feedbackModel.map((feedback) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Usuário X',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '01/01/2023',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Avaliação:'),
                        const SizedBox(width: 8.0),
                        ...buildStarIcons(feedback.rating),
                      ],
                    ),
                    Text(
                      'Avaliação: ${feedback.rating}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text('Comentário:'),
                    Text(
                      feedback.content.toString(),
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void openMoreDetails(SpaceModelTest space) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoreDetails(space: space),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Infos'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: openRatingDialog,
                child: const Text('Avalie'),
              ),
              ElevatedButton(
                onPressed: () => showComments(widget.space),
                child: const Text('Avaliações'),
              ),
              ElevatedButton(
                onPressed: () => openMoreDetails(widget.space),
                child: const Text('Mais Detalhes'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Ver Fotos'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Ver Fotos'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Ver Localização'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
