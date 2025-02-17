import 'package:animate_do/animate_do.dart';
import 'package:festou/src/features/bottomNavBarLocador/bottom_navbar_locador_page.dart';
import 'package:festou/src/features/loading_indicator.dart';
import 'package:festou/src/features/show%20spaces/my%20space%20mvvm/my_spaces_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festou/src/core/ui/helpers/messages.dart';
import 'package:festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';
import 'package:festou/src/features/register/space/space_register_state.dart';
import 'package:festou/src/helpers/helpers.dart';
import 'package:festou/src/helpers/keys.dart';
import 'package:festou/src/models/space_model.dart';

class Revisao extends ConsumerStatefulWidget {
  const Revisao({super.key});

  @override
  ConsumerState<Revisao> createState() => _RevisaoState();
}

class _RevisaoState extends ConsumerState<Revisao> {
  bool isRegistering = false;
  @override
  Widget build(BuildContext context) {
    final newSpaceRegister = ref.watch(newSpaceRegisterVmProvider.notifier);

    ref.listen(newSpaceRegisterVmProvider, (_, state) {
      switch (state) {
        case SpaceRegisterState(status: SpaceRegisterStateStatus.initial):
          break;

        case SpaceRegisterState(status: SpaceRegisterStateStatus.success):
          Messages.showSuccess('Espaço cadastrado com sucesso!', context);

        case SpaceRegisterState(
            status: SpaceRegisterStateStatus.error,
            :final errorMessage?
          ):
          Messages.showError(errorMessage, context);
      }
    });

    final spaceRegisterState = ref.watch(newSpaceRegisterVmProvider);
    final dayHoursMap = {
      'Seg': spaceRegisterState.days!.monday,
      'Ter': spaceRegisterState.days!.tuesday,
      'Qua': spaceRegisterState.days!.wednesday,
      'Qui': spaceRegisterState.days!.thursday,
      'Sex': spaceRegisterState.days!.friday,
      'Sáb': spaceRegisterState.days!.saturday,
      'Dom': spaceRegisterState.days!.sunday,
    };

    void showSuccessDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ZoomIn(
            duration: const Duration(milliseconds: 500),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BounceInDown(
                    duration: const Duration(milliseconds: 600),
                    child: const Icon(
                      Icons.check_circle,
                      color: Color(0xff4CAF50),
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Cadastrado!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              content: const Text(
                "Seu espaço foi cadastrado com sucesso!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                FadeInUp(
                  duration: const Duration(milliseconds: 300),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      backgroundColor: const Color.fromARGB(255, 68, 0, 177),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Stack(
      children: [
        Scaffold(
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
                      offset: const Offset(0, 2),
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
            centerTitle: true,
            title: const Text(
              'Cadastro de espaço',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Resumo do cadastro:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xff4300B1),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Categorias:',
                    style: TextStyle(color: Color(0xff4300B1)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text(spaceRegisterState.selectedTypes.join(', ')),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Endereço:',
                    style: TextStyle(color: Color(0xff4300B1)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bairro: ${spaceRegisterState.bairro}'),
                        Text('CEP: ${spaceRegisterState.cep}'),
                        Text('Cidade: ${spaceRegisterState.cidade}'),
                        Text('Logradouro: ${spaceRegisterState.logradouro}'),
                        Text('Número: ${spaceRegisterState.numero}'),
                        Text('Estado: ${spaceRegisterState.estado}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Serviços:',
                    style: TextStyle(color: Color(0xff4300B1)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text(spaceRegisterState.selectedServices.join(', ')),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Fotos:',
                    style: TextStyle(color: Color(0xff4300B1)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child:
                        Text('${spaceRegisterState.imageFiles.length} fotos'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Vídeos:',
                    style: TextStyle(color: Color(0xff4300B1)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child:
                        Text('${spaceRegisterState.videoFiles.length} vídeos'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Nome do espaço:',
                    style: TextStyle(color: Color(0xff4300B1)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text(spaceRegisterState.titulo),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Descrição do espaço:',
                    style: TextStyle(color: Color(0xff4300B1)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text(spaceRegisterState.descricao),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Preço do espaço:',
                    style: TextStyle(color: Color(0xff4300B1)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text(
                        'R\$ ${trocarPontoPorVirgula(spaceRegisterState.preco)}'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Calendário:',
                    style: TextStyle(color: Color(0xff4300B1)),
                  ),
                  ...dayHoursMap.entries.map((entry) {
                    final dayName = entry.key;
                    final Hours? hours = entry.value;

                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: SizedBox(width: 40, child: Text(dayName)),
                        ),
                        // const SizedBox(
                        //   width: 20,
                        // ),
                        Text(
                          hours != null
                              ? " - ${hours.from}h às ${hours.to}h"
                              : " - Fechado",
                        ),
                      ],
                    );
                  }),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 24),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //           'Seg - ${spaceRegisterState.days!.monday!.from}h às ${spaceRegisterState.days!.monday!.to}h'),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 38.0, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    key: Keys.k10ScreenButton,
                    onTap: () async {
                      try {
                        isRegistering = true;
                        setState(() {});
                        await newSpaceRegister.register();
                        isRegistering = false;
                        setState(() {});

                        // 🚀 Atualiza automaticamente a lista de espaços
                        ref.invalidate(mySpacesVmProvider);

                        // Redireciona o usuário após o cadastro
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const BottomNavBarLocadorPage(),
                          ),
                        );
                        showSuccessDialog(context);
                      } on Exception {
                        return;
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 9),
                      alignment: Alignment.center,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff9747FF),
                            Color(0xff44300b1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: const Text(
                        'Concluir',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 9),
                      alignment: Alignment.center,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff9747FF),
                            Color(0xff44300b1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: const Text(
                        'Voltar',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
        if (isRegistering)
          decContainer(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CustomLoadingIndicator()))
      ],
    );
  }
}
