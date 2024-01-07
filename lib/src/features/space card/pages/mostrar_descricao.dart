import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class MostrarDescricao extends StatefulWidget {
  final SpaceModel space;
  const MostrarDescricao({
    super.key,
    required this.space,
  });

  @override
  State<MostrarDescricao> createState() => _MostrarDescricaoState();
}

class _MostrarDescricaoState extends State<MostrarDescricao> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre este espaço'),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
              'Bem-vindo ao nosso espaço, um verdadeiro oásis de aconchego e estilo. Situado em um local encantador, nosso espaço foi cuidadosamente projetado para oferecer uma experiência única, onde o conforto se encontra com a elegância. Ao adentrar este refúgio, você será recebido por uma atmosfera calorosa e acolhedora, proporcionando um ambiente perfeito para relaxar e descontrair.A decoração, meticulosamente escolhida, reflete a essência do aconchego, combinando elementos modernos com toques de charme tradicional. Cada detalhe foi pensado para criar uma atmosfera que faz você se sentir em casa desde o primeiro momento. Os tons suaves das paredes, os móveis confortáveis e os acessórios cuidadosamente selecionados se unem para criar um espaço que é simultaneamente elegante e acolhedor.Nosso espaço oferece uma variedade de amenidades para garantir uma estadia relaxante e agradável. A sala de estar é um convite ao descanso, com sofás macios e uma decoração que transmite tranquilidade. A área de refeições é perfeita para desfrutar de refeições deliciosas em um ambiente agradável e íntimo.O quarto principal é um santuário de serenidade, com uma cama luxuosa que proporciona noites de sono repousantes. A iluminação suave e a decoração cuidadosamente escolhida criam um ambiente propício para relaxar após um dia agitado.Além disso, nosso espaço possui uma cozinha totalmente equipada, ideal para preparar refeições deliciosas. Se preferir, você pode desfrutar de momentos de tranquilidade no nosso espaço ao ar livre, seja em uma varanda encantadora ou em um jardim bem cuidado.A localização estratégica do nosso espaço permite fácil acesso a diversas atrações locais, garantindo que você possa explorar a área com facilidade. Seja para uma escapada romântica, uma viagem de negócios ou simplesmente para recarregar as energias, nosso espaço oferece o ambiente perfeito.Em resumo, nosso espaço é mais do que um local para ficar; é uma experiência de aconchego, um refúgio que convida você a relaxar e desfrutar do melhor que a vida tem a oferecer. Estamos ansiosos para recebê-lo em nosso espaço aconchegante e tornar a sua estadia memorável e inesquecível.'),
        ),
      ),
    );
  }
}
