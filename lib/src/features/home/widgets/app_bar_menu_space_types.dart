import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/application_providers.dart';

class AppBarMenuSpaceTypes extends ConsumerStatefulWidget {
  const AppBarMenuSpaceTypes({super.key});

  @override
  ConsumerState<AppBarMenuSpaceTypes> createState() => _AppBarMenuSpaceTypesState();
}

class _AppBarMenuSpaceTypesState extends ConsumerState<AppBarMenuSpaceTypes> {
  final user = FirebaseAuth.instance.currentUser!;

  String formatString(String input) {
    if (input.isEmpty) return '';

    // Limita a string a 6 caracteres
    String truncated = input.length > 6 ? input.substring(0, 6) : input;

    // Converte a primeira letra para maiúscula e o restante para minúscula
    return truncated[0].toUpperCase() + truncated.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;
    return SliverAppBar(
      expandedHeight: y * 0.25,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: x * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Olá, ${formatString(user.email!)}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      ref.read(logoutProvider.future);
                    },
                  ),
                ],
              ),
              // Lista horizontal de botões
              SizedBox(
                height: y * 0.12,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: y * 0.01),
                      child: SizedBox(
                        width: x * 0.41,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'lib/assets/images/iconKids.png',
                                width: x * 0.12,
                              ),
                              SizedBox(width: x * 0.02),
                              const Text(
                                'Kids',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        width: x * 0.025),
                    Padding(
                      padding: EdgeInsets.only(bottom: y * 0.01),
                      child: SizedBox(
                        width: x * 0.41,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'lib/assets/images/iconBuque.png',
                                width: x * 0.12,
                              ),
                              SizedBox(width: x * 0.02),
                              const Text(
                                'Casamento',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: x * 0.025),
                    Padding(
                      padding: EdgeInsets.only(bottom: y * 0.01),
                      child: SizedBox(
                        width: x * 0.41,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'lib/assets/images/iconQuinze.png',
                                width: x * 0.12,
                              ),
                              SizedBox(width: x * 0.02),
                              const Text(
                                'Debutante',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: x * 0.025),
                    Padding(
                      padding: EdgeInsets.only(bottom: y * 0.01),
                      child: SizedBox(
                        width: x * 0.41,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'lib/assets/images/iconReligioso.png',
                                width: x * 0.12,
                              ),
                              SizedBox(width: x * 0.02),
                              const Text(
                                'Religioso',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: x * 0.025),
                    Padding(
                      padding: EdgeInsets.only(bottom: y * 0.01),
                      child: SizedBox(
                        width: x * 0.41,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'lib/assets/images/iconCha.png',
                                width: x * 0.12,
                              ),
                              SizedBox(width: x * 0.02),
                              const Text(
                                'Chá',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: x * 0.025),
                    Padding(
                      padding: EdgeInsets.only(bottom: y * 0.01),
                      child: SizedBox(
                        width: x * 0.41,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'lib/assets/images/iconReuniao.png',
                                width: x * 0.12,
                              ),
                              SizedBox(width: x * 0.02),
                              const Text(
                                'Reunião',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: x * 0.025),
                    Padding(
                      padding: EdgeInsets.only(bottom: y * 0.01),
                      child: SizedBox(
                        width: x * 0.41,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'lib/assets/images/iconOutros.png',
                                width: x * 0.12,
                              ),
                              SizedBox(width: x * 0.02),
                              const Text(
                                'Outros',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: x * 0.025),
                  ],
                ),
              ),
              SizedBox(height: y * 0.015), // Espaçamento entre a lista de botões e o resto do conteúdo
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () =>
                        Navigator.of(context)
                            .pushNamed('/home/all_spaces', arguments: user),
                    child: Container(
                      padding: EdgeInsets.all(
                          x * 0.02),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: const Text(
                        'Todos os espaços',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        Navigator.of(context)
                            .pushNamed('/home/my_spaces', arguments: user),
                    child: Container(
                      padding: EdgeInsets.all(
                          x * 0.02),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: const Text(
                        'Meus espaços cadastrados',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      pinned: false,
    );
  }
}