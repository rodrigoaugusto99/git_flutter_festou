import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:git_flutter_festou/src/features/bottomNavBar/profile/profile_status.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/profile_vm.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/bottomNavBarPageLocador.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/menu/menu.dart';
import 'package:git_flutter_festou/src/features/custom_app_bar.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';
import 'package:git_flutter_festou/src/features/widgets/my_rows_config.dart';
import 'package:svg_flutter/svg.dart';

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
      backgroundColor: const Color(0xffF8F8F8),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Container(
            decoration: BoxDecoration(
              //color: Colors.white.withOpacity(0.7),
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Perfil',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 30),
          child: profileVm.when(
            data: (ProfileState data) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //avatar
                  data.userModel!.avatarUrl != ''
                      ? Align(
                          child: CircleAvatar(
                            backgroundImage: Image.network(
                              data.userModel!.avatarUrl,
                              fit: BoxFit.cover,
                            ).image,
                            radius: 50,
                          ),
                        )
                      : const CircleAvatar(
                          radius: 100,
                          child: Icon(
                            Icons.person,
                          ),
                        ),
                  //nome
                  const SizedBox(height: 15),
                  Align(
                    child: Column(
                      children: [
                        Text(
                          data.userModel!.name,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 1.2),
                        ),
                        Align(
                          //alignment: Alignment.topCenter,
                          child: Text(
                            data.userModel!.email,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  MyText(text: 'Configurações'),
                  const SizedBox(height: 25),
                  MyRowsConfig(userModel: data.userModel!),
                  const SizedBox(height: 10),
                  MyText(text: 'Locação'),
                  const SizedBox(height: 25),
                  MyRow(
                    text: 'Quero disponibilizar um espaço',
                    icon1: Image.asset(
                      'lib/assets/images/Icon Disponibilizarcasinha.png',
                    ),
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
                    icon1: Image.asset(
                      'lib/assets/images/Icon Atendimentocentral.png',
                    ),
                    onTap: () {},
                  ),

                  const SizedBox(height: 10),
                  MyText(text: 'Jurídico'),
                  const SizedBox(height: 25),
                  MyRow(
                    text: 'Termos de Serviço',
                    icon1: Image.asset(
                      'lib/assets/images/Icon Termosjuridic.png',
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  MyText(text: 'Outros'),
                  const SizedBox(height: 25),
                  MyRow(
                    text: 'Termos de Serviço',
                    icon1: Image.asset(
                      'lib/assets/images/Icon Sairsairdofestoyu.png',
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 70),
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
    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  );
}
