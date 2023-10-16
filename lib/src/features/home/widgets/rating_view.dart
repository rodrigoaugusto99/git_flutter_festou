import 'dart:developer' as developer;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class RatingView extends StatefulWidget {
  final SpaceModel space;
  const RatingView({super.key, required this.space});

  @override
  State<RatingView> createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  final _ratingPageController = PageController();

  //posicao inicial das stars(se o dialog tem 300, entao top:200 deve ta bom)
  var _starPosition = 200.0;

  //variavel auxiliar para coloração das ESTRELAS de acordo com o clique
  var starRatingIndex = 0;

  //variavel auxiliar para visibilidade de acordo com o clique
  var _isMoreDetailActive = false;

  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      //para a borda do Container ser respeitada pelo botao Done
      clipBehavior: Clip.antiAlias,
      //Stack - para configurar os elementos facilmente com Positioned
      child: Stack(
        children: [
          //thanks note
          SizedBox(
            height: max(300, MediaQuery.of(context).size.height * 0.3),
            child: PageView(
              controller: _ratingPageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                buildThanksNote(),
                causeOfRating(),
              ],
            ),
          ),
          //done button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.red,
              child: MaterialButton(
                onPressed: () {
                  developer.log(
                      'stars: $starRatingIndex - content: ${contentController.text} - espaco enviado para o saveRating: ${widget.space}');
                  saveRating(
                      starRatingIndex, contentController.text, widget.space);
                  Navigator.pop(context);
                },
                textColor: Colors.white,
                child: const Text('Done'),
              ),
            ),
          ),
          //skip button
          Positioned(
            right: 0,
            child: MaterialButton(
              onPressed: _hideDialog,
              child: const Text('Skip'),
            ),
          ),
          //Star rating
          AnimatedPositioned(
            /*é animado:
            esse TOP muda dinamicamente, pois instanciei 
            como variavel e seu valor muda com setState*/
            //decorando de acordo com o INDEX
            top: _starPosition,
            left: 0, //not worked
            right: 0, //not worked
            duration: const Duration(milliseconds: 300),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, //worked
              children: List.generate(
                5,
                (index) => IconButton(
                  /*Coloração das estrelas:
                  -de acordo com cada index da estrela
                  e com o _starRating sendo atribuido com 
                  o index + 1 da estrela clicada.*/
                  icon: Icon(
                    //decorando de acordo com o INDEX
                    index < starRatingIndex ? Icons.star : Icons.star_border,
                    size: 32,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      //animando - trocando a pagina da PageView
                      _ratingPageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );

                      //animando - trocando valor da posição das stars ao clicar em qualquer uma
                      //MUDANDO INDEX
                      _starPosition = 20.0;

                      /*se clicar na terceira estrela, _starRating
                      receberá o valor do index dessa estrela. */
                      //MUDANDO INDEX
                      starRatingIndex = index + 1;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//paginas
  buildThanksNote() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Thanks',
          style: TextStyle(
            fontSize: 24,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text('We\'d love to get your feedback'),
        Text('How was your experience?'),
      ],
    );
  }

  causeOfRating() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Visibility(
          visible: !_isMoreDetailActive,

          // ignore: sort_child_properties_last
          child: Column(
            //tamanho minimo para todos os elementos irem para o centro
            mainAxisSize: MainAxisSize.min,
            children: [
              //More button
              InkWell(
                onTap: () {
                  setState(() {
                    _isMoreDetailActive = true;
                  });
                },
                child: const Text(
                  'Quer fazer um comentário?',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          //quando a propriedade visible is false
          replacement: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey), // Cor da borda
              borderRadius: BorderRadius.circular(8.0), // Raio das bordas
            ),
            child: TextField(
              maxLines: 5,
              autofocus: true,
              controller: contentController,
              decoration: InputDecoration(
                  hintText: 'Write your review here...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: InputBorder.none),
            ),
          ),
        ),
      ],
    );
  }

  _hideDialog() {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  void saveRating(int starRatingIndex, String text, SpaceModel space) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final spaceId = widget.space.spaceId;

    // Consulta todos os documentos na coleção "users"
    QuerySnapshot querySnapshot = await users.get();

    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot userDoc in querySnapshot.docs) {
        developer.log('Documento de usuário procurado: ${userDoc.id}\n.');
        // Obtenha os dados do documento do usuário como um mapa
        final userData = userDoc.data() as Map<String, dynamic>;
        // Obtenha o array "user_spaces" do documento do usuário
        final userSpaces = userData['user_spaces'] as List<dynamic>?;

        if (userSpaces != null) {
          for (Map<String, dynamic> spaceMap in userSpaces) {
            developer.log(
                'Espaço ID procurado do usuário procurado: ${spaceMap['space_id']}');
            if (spaceMap['space_id'] == spaceId) {
              developer.log('ACHOUU espaco com id igual!!!\n.');
              // Agora você encontrou o espaço com "space_id" igual a "spaceId"
              // Crie o mapa com os dados da avaliação
              final Map<String, dynamic> ratingData = {
                'starRating': starRatingIndex,
                'text': text,
              };
              developer.log('feedback mapeado: $ratingData');

              // Verifique se a lista "space_ratings" já existe no mapa, senão crie-a
              if (spaceMap['space_ratings'] == null) {
                developer.log('criou o mapa space_ratings');
                spaceMap['space_ratings'] = [ratingData];
              } else {
                developer.log('adicionando no mapa existente');
                // Caso contrário, adicione o novo ratingData à lista existente
                spaceMap['space_ratings'].add(ratingData);
              }
              // Atualize o documento do usuário no Firestore com os novos dados
              // Usando "userDoc.id" como ID do documento do usuário
              await users.doc(userDoc.id).update({'user_spaces': userSpaces});
              developer.log('Avaliação salva com sucesso');
            } else {
              developer.log(
                  'espaço não encontrado com esse id\n(id procuraddo: $spaceId\n.');
            }
          }
        }
      }
    } else {
      developer.log('Nenhum documento de usuário encontrado.');
    }
  }
}
