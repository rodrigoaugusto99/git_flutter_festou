import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/bottomNavBarPageLocador.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/menu/menu.dart';
import 'package:git_flutter_festou/src/features/widgets/my_rows_config.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:git_flutter_festou/src/services/user_service.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
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
              return const Center(child: CircularProgressIndicator());
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
                  return const Center(child: CircularProgressIndicator());
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
                final updatedUserModel = UserModel(
                  email: data['email'] ?? '',
                  name: data['name'] ?? '',
                  cpf: data['cpf'] ?? '',
                  cep: data['user_address']?['cep'] ?? '',
                  logradouro: data['user_address']?['logradouro'] ?? '',
                  telefone: data['telefone'] ?? '',
                  bairro: data['user_address']?['bairro'] ?? '',
                  cidade: data['user_address']?['cidade'] ?? '',
                  id: userModel.id,
                  doc1Url: data['doc1_url'] ?? '',
                  doc2Url: data['doc2_url'] ?? '',
                  avatarUrl: data['avatar_url'] ?? '',
                );

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
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  NetworkImage(updatedUserModel.avatarUrl),
                            ),
                          ),
                        )
                      else
                        const CircleAvatar(
                          radius: 50,
                          child: Icon(
                            Icons.person,
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
                                  fontWeight: FontWeight.bold,
                                  height: 1.2),
                            ),
                            Align(
                              child: Text(
                                updatedUserModel.email,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
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
                        text: 'Quero disponibilizar um espaço',
                        icon1: Image.asset(
                          'lib/assets/images/Icon Disponibilizarcasinha.png',
                        ),
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const BottomNavBarPageLocador(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      myText(text: 'Atendimento'),
                      const SizedBox(height: 15),
                      myRow(
                        text: 'Central de Ajuda',
                        icon1: Image.asset(
                          'lib/assets/images/Icon Atendimentocentral.png',
                        ),
                        onTap: () {},
                      ),
                      const SizedBox(height: 25),
                      myText(text: 'Jurídico'),
                      const SizedBox(height: 15),
                      myRow(
                        text: 'Termos de Serviço',
                        icon1: Image.asset(
                          'lib/assets/images/Icon Termosjuridic.png',
                        ),
                        onTap: () {},
                      ),
                      const SizedBox(height: 25),
                      myText(text: 'Outros'),
                      const SizedBox(height: 15),
                      myRow(
                        text: 'Termos de Serviço',
                        icon1: Image.asset(
                          'lib/assets/images/Icon Sairsairdofestoyu.png',
                        ),
                        onTap: () {},
                      ),
                      const SizedBox(height: 100),
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
