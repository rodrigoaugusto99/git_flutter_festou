import 'package:flutter/material.dart';
import 'package:festou/src/features/space%20card/widgets/new_card_info.dart';
import 'package:festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:festou/src/models/space_model.dart';
import 'package:lottie/lottie.dart';

class MySliverListFiltered extends StatelessWidget {
  final List<SpaceModel> spaces;
  const MySliverListFiltered({
    super.key,
    required this.spaces,
  });

  @override
  Widget build(BuildContext context) {
    if (spaces.isEmpty) {
      return SliverToBoxAdapter(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'lib/assets/animations/not_found.json',
                  width: 200,
                  height: 200,
                  repeat: true,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Nenhum espaço encontrado!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tente ajustar sua busca para encontrar os melhores espaços disponíveis.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton.icon(
                  onPressed: () {
                    // _controller.clear();
                    // searchViewModel.onChangedSearch('');
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text('Tentar Novamente'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => InkWell(
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewCardInfo(
                      spaceId: spaces[index].spaceId,
                    ),
                  ),
                ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: NewSpaceCard(
                hasHeart: true,
                space: spaces[index],
                isReview: false,
              ),
            )),
        childCount: spaces.length,
      ),
    );
  }
}
