import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_card_info.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';

class MySliverListToCardInfo extends StatelessWidget {
  final data;
  final AsyncValue spaces;
  final bool x;

  const MySliverListToCardInfo({
    Key? key,
    required this.data,
    required this.spaces,
    required this.x,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final y = MediaQuery.of(context).size.height;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= 0 && index < data.spaces.length) {
            // Verifique se o índice é válido antes de acessar a lista
          } else {
            // Índice inválido, retorne um widget vazio ou de carregamento, conforme necessário
            return Container();
          }
          return null;
        },
        childCount: data.spaces.length,
      ),
    );
  }
}
