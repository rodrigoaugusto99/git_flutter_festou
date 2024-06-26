import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_card_info.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';

class MySliverListToCardInfo extends StatelessWidget {
  final data;
  final AsyncValue spaces;
  final bool x;
  bool isLocadorFlow;

  MySliverListToCardInfo({
    Key? key,
    required this.data,
    required this.spaces,
    required this.x,
    this.isLocadorFlow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final y = MediaQuery.of(context).size.height;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index >= 0 && index < data.spaces.length) {
          // Verifique se o índice é válido antes de acessar a lista
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewCardInfo(space: data.spaces[index]),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: y * 0.03),
              child: NewSpaceCard(
                isLocadorFlow: isLocadorFlow,
                hasHeart: x,
                space: data.spaces[index],
                isReview: false,
              ),
            ),
          );
        } else {
          // Índice inválido, retorne um widget vazio ou de carregamento, conforme necessário
          return Container();
        }
      },
      itemCount: data.spaces.length,
    );
  }
}
