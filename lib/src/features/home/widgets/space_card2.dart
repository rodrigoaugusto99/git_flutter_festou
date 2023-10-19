import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/features/home/widgets/card_infos.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class SpaceCard2 extends StatefulWidget {
  final SpaceModel space;
  const SpaceCard2({
    super.key,
    required this.space,
  });

  @override
  State<SpaceCard2> createState() => _SpaceCard2State();
}

final user = FirebaseAuth.instance.currentUser!;

class _SpaceCard2State extends State<SpaceCard2> {
  /*Future<void> toggleFavoriteSpace(String spaceId) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');

    QuerySnapshot querySnapshot =
        await users.where("uid", isEqualTo: user.uid).get();

    if (querySnapshot.docs.length == 1) {
      final userDocument = querySnapshot.docs.first;
      String x;
      if (widget.space.isFavorited) {
        userDocument.reference.update({
          'spaces_favorite': FieldValue.arrayUnion([spaceId]),
        });
        x = 'add';
      } else {
        userDocument.reference.update({
          'spaces_favorite': FieldValue.arrayRemove([spaceId]),
        });
        x = 'removed';
      }

      log('sucesso! - $x -  $spaceId');
    } else {
      log('Documento do usuário não encontrado');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        child: Column(
          children: [
            SizedBox(
              height: 240,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Container(
                      height: 220,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(ImageConstants.gliterBlackground),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.space.email),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    widget.space.isFavorited =
                                        !widget.space.isFavorited;
                                  });
                                  //toggleFavoriteSpace(widget.space.spaceId);
                                },
                                child: widget.space.isFavorited
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.favorite_outline,
                                      ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.space.name,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CardInfos(
                                          space: widget.space,
                                        ),
                                      ),
                                    ),
                                    child: const Icon(Icons.info),
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: const Icon(Icons.edit),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(widget.space.cep),
                          Text(widget.space.logradouro),
                          Text(widget.space.numero),
                          Text(widget.space.bairro),
                          Text(widget.space.cidade),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
