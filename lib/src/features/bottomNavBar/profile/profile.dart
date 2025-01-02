import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/bottomNavBarLocatarioPage.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/central/central_de_ajuda.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/register_signature.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/bottomNavBarLocadorPage.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/menu/menu.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/privacy_policy_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/service_terms_page.dart';
import 'package:git_flutter_festou/src/features/widgets/my_rows_config.dart';
import 'package:git_flutter_festou/src/helpers/keys.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:git_flutter_festou/src/services/user_service.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() async {
    userModel = await UserService().getCurrentUserModel();
    setState(() {});
  }

  Future<bool> hasActiveContract(String clientId) async {
    final now = DateTime.now();
    final querySnapshot = await FirebaseFirestore.instance
        .collection('reservations')
        .where('client_id', isEqualTo: clientId)
        .get();

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final selectedFinalDate = DateTime.parse(data['selectedFinalDate']);
      final checkOutTime = data['checkOutTime'];

      if (selectedFinalDate.isAfter(now) ||
          selectedFinalDate.day == now.day &&
              selectedFinalDate.month == now.month &&
              selectedFinalDate.year == now.year &&
              checkOutTime >= now.hour) {
        return true;
      }
    }
    return false;
  }

  void navigateBasedOnContract(BuildContext context) async {
    if (userModel == null) return;

    if (userModel!.locador) {
      final hasSpaces = await hasRegisteredSpaces(userModel!.id);

      if (hasSpaces) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Espaços Registrados'),
            content: const Text(
                'Você possui espaços cadastrados no seu nome e não pode mudar para locatário.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmação de Mudança'),
            content: const Text(
                'Você não poderá mais disponibilizar espaços a partir da mudança, podendo apenas alugar. Deseja continuar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BottomNavBarLocatarioPage(),
                    ),
                  );
                },
                child: const Text('Confirmar'),
              ),
            ],
          ),
        );
      }
    } else {
      final hasContract = await hasActiveContract(userModel!.id);

      if (hasContract) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Contrato de Locação Ativo'),
            content: const Text(
                'Você possui um contrato de locação ativo e não pode mudar para locador.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmação de Mudança'),
            content: const Text(
                'Você não poderá mais alugar espaços a partir da mudança, podendo apenas disponibilizar. Deseja continuar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                key: Keys.kDialogConfirm,
                onPressed: () async {
                  final response = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterSignature(),
                    ),
                  );
                  if (response == null) return;
                  if (response) {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNavBarLocadorPage(),
                      ),
                    );
                  }
                },
                child: const Text('Confirmar'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<bool> hasRegisteredSpaces(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('spaces')
        .where('user_id', isEqualTo: userId)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    UserService userService = UserService();
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Perfil',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFFF8F8F8),
        surfaceTintColor: const Color(0xFFF8F8F8),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 30),
        child: FutureBuilder<UserModel?>(
          future: userService.getCurrentUserModel(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CustomLoadingIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar os dados.'));
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Usuário não encontrado.'));
            }

            final userModel = snapshot.data!;

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('uid', isEqualTo: userModel.id)
                  .limit(1)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CustomLoadingIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Erro ao carregar os dados.'));
                }
                if (snapshot.hasData && !snapshot.data!.docs[0].exists) {
                  return const Center(child: Text('Usuário não encontrado.'));
                }

                final data =
                    snapshot.data!.docs[0].data() as Map<String, dynamic>;
                UserModel updatedUserModel = UserModel.fromMap(data);

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      if (updatedUserModel.avatarUrl.isNotEmpty)
                        Align(
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return Scaffold(
                                    appBar: AppBar(
                                      backgroundColor: const Color(0xffffffff),
                                      title: const Text('Minha foto'),
                                    ),
                                    body: Center(
                                      child: Image.network(
                                          updatedUserModel.avatarUrl),
                                    ),
                                  );
                                },
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  width: 105,
                                  height: 105,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      NetworkImage(updatedUserModel.avatarUrl),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Align(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 110,
                                height: 110,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 105,
                                height: 105,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              CircleAvatar(
                                  radius: 50,
                                  child: updatedUserModel.name.isNotEmpty
                                      ? Text(
                                          updatedUserModel.name[0],
                                          style: const TextStyle(fontSize: 52),
                                        )
                                      : const Icon(
                                          Icons.person,
                                          size: 40,
                                        )),
                            ],
                          ),
                        ),
                      const SizedBox(height: 15),
                      // Nome e Email
                      Align(
                        child: Column(
                          children: [
                            Text(
                              updatedUserModel.name,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2),
                            ),
                            Align(
                              child: Text(
                                updatedUserModel.email,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      myText(text: 'Configurações'),
                      const SizedBox(height: 15),
                      MyRowsConfig(userModel: updatedUserModel),
                      const SizedBox(height: 25),
                      myText(text: 'Locação'),
                      const SizedBox(height: 15),
                      myRow(
                        customKey: Keys.kProfileViewLocador,
                        text: userModel.locador
                            ? 'Quero deixar de ser um locador'
                            : 'Quero disponibilizar um espaço',
                        icon1: Image.asset(
                          'lib/assets/images/Icon Disponibilizarcasinha.png',
                        ),
                        onTap: () => navigateBasedOnContract(context),
                      ),
                      const SizedBox(height: 25),
                      myText(text: 'Atendimento'),
                      const SizedBox(height: 15),
                      myRow(
                        text: 'Central de Ajuda',
                        icon1: Image.asset(
                          'lib/assets/images/Icon Atendimentocentral.png',
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CentralDeAjuda(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      myText(text: 'Jurídico'),
                      const SizedBox(height: 15),
                      myRow(
                        text: 'Termos de Serviço',
                        icon1: Image.asset(
                          'lib/assets/images/Icon Termosjuridic.png',
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ServiceTermsPage()),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      myRow(
                        text: 'Política de privacidade',
                        icon1: Image.asset(
                          'lib/assets/images/icon_politica.png',
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PrivacyPolicyPage()),
                          );
                        },
                      ),
                      const SizedBox(height: 25),
                      myText(text: 'Outros'),
                      const SizedBox(height: 15),
                      myRow(
                        text: 'Sair do Festou',
                        icon1: Image.asset(
                          'lib/assets/images/Icon Sairsairdofestoyu.png',
                        ),
                        onTap: () {
                          ref.invalidate(userFirestoreRepositoryProvider);
                          ref.invalidate(userAuthRepositoryProvider);
                          ref.read(logoutProvider.future);
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

Widget myText({required String text}) {
  return Text(
    text,
    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  );
}
