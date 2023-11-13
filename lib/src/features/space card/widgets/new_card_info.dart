import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/space%20card/pages/mostrar_denunciar_anuncio.dart';
import 'package:git_flutter_festou/src/features/space%20card/pages/mostrar_descricao.dart';

import 'package:git_flutter_festou/src/features/space%20card/widgets/show_new_map.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/show_map.dart';
import 'package:git_flutter_festou/src/features/register/feedback/feedback_register_page.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_page_limited.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_page_all.dart';
import 'package:git_flutter_festou/src/features/space%20card/pages/mostrar_disponibilidade.dart';
import 'package:git_flutter_festou/src/features/space%20card/pages/mostrar_onde_voce_estara.dart';
import 'package:git_flutter_festou/src/features/space%20card/pages/mostrar_politica_de_cancelamento.dart';
import 'package:git_flutter_festou/src/features/space%20card/pages/mostrar_regras.dart';
import 'package:git_flutter_festou/src/features/space%20card/pages/mostrar_seguranca_propriedade.dart';
import 'package:git_flutter_festou/src/features/space%20card/pages/mostrar_todas_comodidades.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class NewCardInfo extends StatefulWidget {
  final SpaceWithImages space;
  const NewCardInfo({
    super.key,
    required this.space,
  });

  @override
  State<NewCardInfo> createState() => _NewCardInfoState();
}

int _currentSlide = 0;

class _NewCardInfoState extends State<NewCardInfo> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            elevation: 0,
            foregroundColor: Colors.black,
            backgroundColor: innerBoxIsScrolled
                ? Colors.white // Cor do appBar quando scroll para baixo
                : Colors.transparent, // Cor do appBar quando no topo
            snap: true,
            floating: true,
            title: const Text('Test'),
            pinned: false,
          )
        ],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CarouselSlider(
                    items: widget.space.imageUrls
                        .map((imageUrl) => Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            ))
                        .toList(),
                    options: CarouselOptions(
                      aspectRatio: 16 / 12,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentSlide = index;
                        });
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 20.0,
                    right: 20.0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 10),
                      child: Text(
                        '${_currentSlide + 1}/${widget.space.imageUrls.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () => showRatingDialog(widget.space.space),
                child: const Text('Avalie'),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' ${widget.space.space.name} \u2022 500m do Parque Lage',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.space.space.bairro}, ${widget.space.space.cidade}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: _getColor(
                                double.parse(widget.space.space.averageRating)),
                          ),
                          height: 35, // Ajuste conforme necessário
                          width: 25, // Ajuste conforme necessário
                          child: Center(
                            child: Text(
                              double.parse(widget.space.space.averageRating)
                                  .toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white, // Cor do texto
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${widget.space.space.numComments} comments',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 0.4, color: Colors.grey),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.account_circle, // Substitua pelo ícone desejado
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Locador: ${widget.space.space.locadorName}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 0.4, color: Colors.grey),
                    const SizedBox(height: 10),
                    const Text(
                      'Bem-vindo ao nosso espaço, um verdadeiro oásis de aconchego e estilo. Situado em um local encantador,'
                      'nosso espaço foi cuidadosamente projetado para oferecer uma experiência única, onde o conforto se encontra'
                      'com a elegância. Ao adentrar este refúgio, você será recebido por uma atmosfera calorosa e acolhedora, '
                      'proporcionando um ambiente perfeito para relaxar e descontrair.A decoração, meticulosamente escolhida, '
                      'reflete a essência do aconchego, combinando elementos modernos com toques de charme tradicional. '
                      'Cada detalhe foi pensado para criar uma atmosfera que faz você se sentir em casa desde o primeiro '
                      'momento. Os tons suaves das paredes, os móveis confortáveis e os acessórios cuidadosamente '
                      'selecionados se unem para criar um espaço que é simultaneamente elegante e acolhedor.Nosso espaço'
                      'oferece uma variedade de amenidades para garantir uma estadia relaxante e agradável.'
                      'A sala de estar é um convite ao descanso, com sofás macios e uma decoração que transmite tranquilidade.'
                      'A área de refeições é perfeita para desfrutar de refeições deliciosas em um ambiente agradável '
                      'e íntimo.O quarto principal é um santuário de serenidade, com uma cama luxuosa que proporciona '
                      'noites de sono repousantes. A iluminação suave e a decoração cuidadosamente escolhida criam um '
                      'ambiente propício para relaxar após um dia agitado.Além disso, nosso espaço possui uma cozinha'
                      'totalmente equipada, ideal para preparar refeições deliciosas. Se preferir, você pode desfrutar '
                      'e momentos de tranquilidade no nosso espaço ao ar livre, seja em uma varanda encantadora ou em'
                      'um jardim bem cuidado.A localização estratégica do nosso espaço permite fácil acesso a diversas '
                      'atrações locais, garantindo que você possa explorar a área com facilidade. Seja para uma escapada '
                      'romântica, uma viagem de negócios ou simplesmente para recarregar as energias, nosso espaço oferece '
                      'o ambiente perfeito.Em resumo, nosso espaço é mais do que um local para ficar; é uma experiência '
                      'de aconchego, um refúgio que convida você a relaxar e desfrutar do melhor que a vida tem a oferecer.'
                      'Estamos ansiosos para recebê-lo em nosso espaço aconchegante e tornar a sua estadia memorável e inesquecível.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    InkWell(
                      child: const Row(
                        children: [
                          Text(
                            'Mostrar mais',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MostrarDescricao(space: widget.space),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 0.4, color: Colors.grey),
                    const SizedBox(height: 10),
                    const Text(
                      'O que o lugar oferece',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.space.space.selectedServices
                          .take(3)
                          .map((service) => Text(service))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(10)),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Mostrar todas as comodidades',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MostrarTodasComodidades(space: widget.space),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 0.4, color: Colors.grey),
                    const SizedBox(height: 10),
                    const Text(
                      'Onde você estará',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowNewMap(
                              space: widget.space.space,
                            ),
                          ),
                        );
                      },
                      child: AbsorbPointer(
                        absorbing: true,
                        child: ShowMap(
                          space: widget.space.space,
                          scrollGesturesEnabled: false,
                          zoomControlsEnabled: false,
                          zoomGesturesEnabled: false,
                          height: 200,
                          width: double.infinity,
                          x: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '${widget.space.space.bairro}, ${widget.space.space.cidade}',
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'O Bairro dos Mellos é um bairro rural e familiar. \nNão possui mercados, mas fica bem próximo do centro da cidade Piranguçu. Estamos a 1h40min de Campos de Jordão',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    InkWell(
                      child: const Row(
                        children: [
                          Text(
                            'Mostrar mais',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MostrarOndeVoceEstara(space: widget.space),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 0.4, color: Colors.grey),
                    Row(
                      children: [
                        const Text(
                          'Avaliações',
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                              color: _getColor(double.parse(
                                  widget.space.space.averageRating)),
                              borderRadius: BorderRadius.circular(5)),
                          height: 35,
                          width: 25,
                          child: Center(
                            child: Text(
                              double.parse(widget.space.space.averageRating)
                                  .toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '\u2022 ${widget.space.space.numComments} comments',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SpaceFeedbacksPageLimited(
                x: 3,
                space: widget.space.space,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(10)),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Mostrar todos os comentarios',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpaceFeedbacksPageAll(
                                space: widget.space.space),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 0.4, color: Colors.grey),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Alocado por ${widget.space.space.locadorName}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text('Membro desde novembro de 2015'),
                              ],
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons
                                  .account_circle, // Substitua pelo ícone desejado
                              size: 50,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Icon(Icons.star),
                            SizedBox(width: 10),
                            Text('772 avaliações'),
                          ],
                        ),
                        const Row(
                          children: [
                            Icon(Icons.verified),
                            SizedBox(width: 10),
                            Text('Identidade verificada'),
                          ],
                        ),
                        const Row(
                          children: [
                            Icon(Icons.supervisor_account),
                            SizedBox(width: 10),
                            Text('Superhost'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${widget.space.space.locadorName} é Superhost',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                            'Superhosts são locadores experientes, com ótimas avaliações e que se empenham em oferecer estadias incríveis para os locatários.\n'),
                        const SizedBox(height: 10),
                        const Text(
                            'Taxa de resposta: 100%\nTempo de resposta: em até uma hora'),
                        const SizedBox(height: 15),
                        InkWell(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(10),
                                  right: Radius.circular(10)),
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Fale com o locador',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Icon(Icons.security),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Para proteger seu pagamento, nunca transfira dinheiro ou se comunique fora do site ou aplicativo Festou.',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(thickness: 0.4, color: Colors.grey),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Disponibilidade',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text('23 - 28 de jul. de 9999'),
                              ],
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MostrarDisponibilidade(
                                              space: widget.space),
                                    ),
                                  );
                                },
                                child: const Icon(
                                    Icons.arrow_circle_right_outlined)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(thickness: 0.4, color: Colors.grey),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Política de cancelamento',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: 300, // Defina a largura desejada aqui
                                  child: Text(
                                    'Cancelamento gratuito antes de xx/yy. Consulte a política de cancelamento completa do locador, que se aplica mesmo se você cancelar por doenças ou interrupções causadas pela COVID-19',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MostrarPoliticaDeCancelamento(
                                            space: widget.space),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons
                                    .arrow_forward, // Substitua pelo ícone desejado
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(thickness: 0.4, color: Colors.grey),
                        const SizedBox(height: 10),
                        const Text(
                          'Regras do espaço',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Não é permitido animais de estimação'),
                        const Text('Horário de silêncio'),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MostrarRegras(space: widget.space),
                              ),
                            );
                          },
                          child: const Text(
                            'Mostrar mais',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(thickness: 0.4, color: Colors.grey),
                        const SizedBox(height: 10),
                        const Text(
                          'Segurança e propriedade',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Câmera de segurança/dispositivo de gravação',
                        ),
                        const Text(
                            'O Festou proíbe câmeras e dispositivos sem o conhecimento do locatário.'),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MostrarSegurancaPropriedade(
                                        space: widget.space),
                              ),
                            );
                          },
                          child: const Text(
                            'Mostrar mais',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(thickness: 0.4, color: Colors.grey),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.flag),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MostrarDenunciarAnuncio(
                                            space: widget.space),
                                  ),
                                );
                              },
                              child: const Text(
                                'Denunciar este anúncio',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _getColor(double averageRating) {
  if (averageRating >= 4) {
    return Colors.green; // Ícone verde para rating maior ou igual a 4
  } else if (averageRating >= 2 && averageRating < 4) {
    return Colors.orange; // Ícone laranja para rating entre 2 e 4 (exclusive)
  } else {
    return Colors.red; // Ícone vermelho para rating abaixo de 2
  }
}
