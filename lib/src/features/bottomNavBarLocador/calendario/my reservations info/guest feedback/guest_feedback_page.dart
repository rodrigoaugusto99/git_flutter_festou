import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/my%20reservations%20info/guest%20feedback/guest_feedback_page_vm.dart';

class GuestFeedbackPage extends ConsumerStatefulWidget {
  final String userId;
  const GuestFeedbackPage({super.key, required this.userId});

  @override
  ConsumerState<GuestFeedbackPage> createState() => _GuestFeedbackPageState();
}

class _GuestFeedbackPageState extends ConsumerState<GuestFeedbackPage> {
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
    final guestFeedbackRegisterVm =
        ref.watch(guestFeedbackRegisterVmProvider.notifier);

    final errorMessager =
        ref.watch(guestFeedbackRegisterVmProvider.notifier).errorMessage;

    Future.delayed(Duration.zero, () {
      if (errorMessager.toString() != '') {
        Messages.showError(errorMessager, context);
      }
    });

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
            height: math.max(300, MediaQuery.of(context).size.height * 0.3),
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
                  guestFeedbackRegisterVm.register(
                    guestId: widget.userId,
                    rating: starRatingIndex,
                    content: contentController.text,
                  );
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
}
