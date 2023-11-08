import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/home/widgets/more_details.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/new_card_info.dart';
import 'package:git_flutter_festou/src/features/home/widgets/show_map.dart';
import 'package:git_flutter_festou/src/features/home/widgets/ver_fotos.dart';
import 'package:git_flutter_festou/src/features/register/feedback/feedback_register_page.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_page.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';

class CardInfos extends StatefulWidget {
  final SpaceWithImages space;

  const CardInfos({
    super.key,
    required this.space,
  });

  @override
  State<CardInfos> createState() => _CardInfosState();
}

class _CardInfosState extends State<CardInfos> {
  void showRatingDialog(SpaceModel space) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: FeedbackPage(space: space),
        );
      },
    );
  }

  void showAvaliacoes(SpaceModel space) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SpaceFeedbacksPage(space: space);
      },
    );
  }

  void showMoreDetails(SpaceModel space) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoreDetails(space: space),
      ),
    );
  }

  void showNewCardInfo(SpaceModel space) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewCardInfo(space: widget.space),
      ),
    );
  }

  void showMap(SpaceModel space) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ShowMap(space: space),
        );
      },
    );
  }

  void verFotos(SpaceModel space) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: VerFotos(space: space),
        );
      },
    );
  }

  void userInfos(UserModel user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Informações do Usuário:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.deepPurple,
                ),
              ),
              Text(user.email),
              Text(user.name),
              Text(user.telefone),
              Text(user.cep),
              Text(user.logradouro),
              Text(user.bairro),
              Text(user.cidade),
            ],
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
                onPressed: () => showRatingDialog(widget.space.space),
                child: const Text('Avalie'),
              ),
              ElevatedButton(
                onPressed: () => showAvaliacoes(widget.space.space),
                child: const Text('Avaliações'),
              ),
              ElevatedButton(
                onPressed: () => showMoreDetails(widget.space.space),
                child: const Text('Mais Detalhes'),
              ),
              ElevatedButton(
                onPressed: () => showMap(widget.space.space),
                child: const Text('Ver Localização'),
              ),
              ElevatedButton(
                onPressed: () => showNewCardInfo(widget.space.space),
                child: const Text('card infoooo'),
              ),
              //implementar logica pra pegar os dados do usuario que criou o espaço
              /*ElevatedButton(
                onPressed: () => userInfos(widget.user),
                child: const Text('USER INFOS'),
              ),*/
              ElevatedButton(
                onPressed: () => verFotos(widget.space.space),
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
