import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_card_info.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class MySliverListToCardInfo extends StatelessWidget {
  final List<SpaceModel> spaces;
  final bool x;
  bool isLocadorFlow;

  MySliverListToCardInfo({
    super.key,
    required this.spaces,
    required this.x,
    this.isLocadorFlow = false,
  });

  @override
  Widget build(BuildContext context) {
    final y = MediaQuery.of(context).size.height;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index >= 0 && index < spaces.length) {
          // Verifique se o índice é válido antes de acessar a lista
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    NewCardInfo(spaceId: spaces[index].spaceId),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: y * 0.03),
              child: NewSpaceCard(
                isLocadorFlow: isLocadorFlow,
                hasHeart: x,
                space: spaces[index],
                isReview: false,
              ),
            ),
          );
        } else {
          // Índice inválido, retorne um widget vazio ou de carregamento, conforme necessário
          return Container();
        }
      },
      itemCount: spaces.length,
    );
  }
}
