import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:git_flutter_festou/src/features/bottomNavBar/profile/profile_status.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/profile_vm.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/bottomNavBarPageLocador.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/menu/menu.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';
import 'package:git_flutter_festou/src/features/widgets/my_rows_config.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  Widget build(BuildContext context) {
    final profileVm = ref.watch(profileVMProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: profileVm.when(
            data: (ProfileState data) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Perfil',
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nome'),
                            ],
                          ),
                        ],
                      ),
                      Icon(Icons.fork_right),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    thickness: 1.5,
                  ),
                  const SizedBox(height: 10),
                  MyText(text: 'Configurações'),
                  const SizedBox(height: 25),
                  MyRowsConfig(userModel: data.userModel!),
                  const SizedBox(height: 10),
                  MyText(text: 'Alocar'),
                  const SizedBox(height: 25),
                  MyRow(
                    text: 'Quero alocar',
                    icon: const Icon(Icons.abc),
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavBarPageLocador(
                          userModel: data.userModel!,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  MyText(text: 'Atendimento'),
                  const SizedBox(height: 25),
                  MyRow(
                    text: 'Central de Ajuda',
                    icon: const Icon(Icons.abc),
                    onTap: () {},
                  ),
                  MyRow(
                    text: 'Como funciona o Festou',
                    icon: const Icon(Icons.abc),
                    onTap: () {},
                  ),
                  MyRow(
                    text: 'Envie-nos seu feedback',
                    icon: const Icon(Icons.abc),
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  MyText(text: 'Jurídico'),
                  const SizedBox(height: 25),
                  MyRow(
                    text: 'Termos de Serviço',
                    icon: const Icon(Icons.abc),
                    onTap: () {},
                  ),
                  MyRow(
                    text: 'Política de Privacidade',
                    icon: const Icon(Icons.abc),
                    onTap: () {},
                  ),
                ],
              );
            },
            error: (Object error, StackTrace stackTrace) {
              return const Stack(children: [
                Center(child: Icon(Icons.error)),
              ]);
            },
            loading: () {
              return const Stack(children: [
                Center(child: CustomLoadingIndicator()),
              ]);
            },
          ),
        ),
      ),
    );
  }
}

Widget MyText({required String text}) {
  return Text(
    text,
    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  );
}
