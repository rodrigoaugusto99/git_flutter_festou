import 'package:flutter/material.dart';
import 'package:festou/src/features/space%20card/widgets/new_card_info.dart';
import 'package:festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:festou/src/models/space_model.dart';

class MySliverListToCardInfo extends StatelessWidget {
  final List<SpaceModel> spaces;
  final bool x;
  final bool isLocadorFlow;

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
      itemCount: spaces.length,
      itemBuilder: (context, index) {
        bool isLastItem = index == spaces.length - 1;
        double bottomPadding = isLastItem ? y * 0.04 : 0;

        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewCardInfo(spaceId: spaces[index].spaceId),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: y * 0.01, bottom: bottomPadding),
            child: NewSpaceCard(
              isLocadorFlow: isLocadorFlow,
              hasHeart: x,
              space: spaces[index],
              isReview: false,
            ),
          ),
        );
      },
    );
  }
}
