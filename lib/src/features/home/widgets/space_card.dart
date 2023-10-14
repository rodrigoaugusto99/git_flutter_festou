import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/features/home/widgets/card_infos.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';

class SpaceCard extends StatefulWidget {
  final String userEmail;
  final String userName;
  final String userTelefone;
  final String userCep;
  final String userLogradouro;
  final String userBairro;
  final String userCidade;
  final String spaceEmail;
  final String spaceName;
  final String spaceCep;
  final String spaceLogradouro;
  final String spaceNumero;
  final String spaceBairro;
  final String spaceCidade;
  final List<dynamic> selectedTypes;
  final List<dynamic> selectedServices;
  final List<dynamic> availableDays;
  const SpaceCard(
      {super.key,
      required this.userEmail,
      required this.userName,
      required this.userTelefone,
      required this.userCep,
      required this.userLogradouro,
      required this.userBairro,
      required this.userCidade,
      required this.spaceEmail,
      required this.spaceName,
      required this.spaceCep,
      required this.spaceLogradouro,
      required this.spaceNumero,
      required this.spaceBairro,
      required this.spaceCidade,
      required this.selectedTypes,
      required this.selectedServices,
      required this.availableDays});

  @override
  State<SpaceCard> createState() => _SpaceCardState();
}

class _SpaceCardState extends State<SpaceCard> {
  bool isLiked = false;
  String spaceId = '3';
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
                              Text(widget.spaceEmail),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isLiked = !isLiked;
                                  });

                                  // Adicione ou remova o espaço favorito no Firestore
                                  if (isLiked) {
                                    // Adicionar espaço favorito
                                    final user =
                                        FirebaseAuth.instance.currentUser;
                                    spaceId =
                                        '1'; // Substitua pelo ID real do espaço
                                    final userDocRef = FirebaseFirestore
                                        .instance
                                        .collection('users')
                                        .doc(user!.uid);

                                    // Use o método `update` para adicionar o espaço favorito à lista existente
                                    userDocRef.update({
                                      'spaces_favorite':
                                          FieldValue.arrayUnion([spaceId]),
                                    });
                                  } else {
                                    // Remover espaço favorito
                                    final user =
                                        FirebaseAuth.instance.currentUser;
                                    spaceId =
                                        '2'; // Substitua pelo ID real do espaço
                                    final userDocRef = FirebaseFirestore
                                        .instance
                                        .collection('users')
                                        .doc(user!.uid);

                                    // Use o método `update` para remover o espaço favorito da lista
                                    userDocRef.update({
                                      'spaces_favorite':
                                          FieldValue.arrayRemove([spaceId]),
                                    });
                                  }
                                },
                                child: isLiked
                                    ? const Icon(
                                        Icons.favorite_outline,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.spaceName,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CardInfos(
                                          space: SpaceModel(
                                            widget.spaceEmail,
                                            widget.spaceName,
                                            widget.spaceCep,
                                            widget.spaceLogradouro,
                                            widget.spaceNumero,
                                            widget.spaceBairro,
                                            widget.spaceCidade,
                                            widget.selectedTypes,
                                            widget.selectedServices,
                                            widget.availableDays,
                                          ),
                                          user: UserModel(
                                            widget.userEmail,
                                            widget.userName,
                                            widget.userTelefone,
                                            widget.userCep,
                                            widget.userLogradouro,
                                            widget.userBairro,
                                            widget.userCidade,
                                          ),
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
                          Text(widget.spaceCep),
                          Text(widget.spaceLogradouro),
                          Text(widget.spaceNumero),
                          Text(widget.spaceBairro),
                          Text(widget.spaceCidade),
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
