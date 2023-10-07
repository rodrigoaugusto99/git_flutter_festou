import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/home/widgets/card_comments.dart';
import 'package:git_flutter_festou/src/features/home/widgets/more_details.dart';
import 'package:git_flutter_festou/src/features/home/widgets/rating_view.dart';
import 'package:git_flutter_festou/src/features/home/widgets/show_map.dart';
import 'package:git_flutter_festou/src/models/space/space2.dart';

class CardInfos extends StatefulWidget {
  final SpaceModelTest2 space;
  const CardInfos({
    super.key,
    required this.space,
  });

  @override
  State<CardInfos> createState() => _CardInfosState();
}

class _CardInfosState extends State<CardInfos> {
  void showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          child: RatingView(),
        );
      },
    );
  }

  void showComments(SpaceModelTest2 space) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Comentários'),
          content: CardComments(space: space),
        );
      },
    );
  }

  void showMoreDetails(SpaceModelTest2 space) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoreDetails(space: space),
      ),
    );
  }

  void showMap(SpaceModelTest2 space) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ShowMap(
            space: space,
          ),
        );
      },
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
                onPressed: showRatingDialog,
                child: const Text('Avalie'),
              ),
              ElevatedButton(
                onPressed: () => showComments(widget.space),
                child: const Text('Avaliações'),
              ),
              ElevatedButton(
                onPressed: () => showMoreDetails(widget.space),
                child: const Text('Mais Detalhes'),
              ),
              ElevatedButton(
                onPressed: () => showMap(widget.space),
                child: const Text('Ver Localização'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Ver Fotos'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Ver Fotos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
