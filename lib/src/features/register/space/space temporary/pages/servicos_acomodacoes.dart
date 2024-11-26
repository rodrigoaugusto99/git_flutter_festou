import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/adicione_fotos.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';

import 'package:git_flutter_festou/src/features/register/space/widgets/services_panel.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/type_panel.dart';

class ServicosAcomodacoes extends ConsumerStatefulWidget {
  const ServicosAcomodacoes({super.key});

  @override
  ConsumerState<ServicosAcomodacoes> createState() =>
      _ServicosAcomodacoesState();
}

class _ServicosAcomodacoesState extends ConsumerState<ServicosAcomodacoes> {
  @override
  Widget build(BuildContext context) {
    final newSpaceRegister = ref.read(newSpaceRegisterVmProvider.notifier);
    return Scaffold(
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
          'Cadastrar',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38.0, vertical: 20),
        child: Column(
          children: [
            Column(
              children: [
                const Text(
                  'Informe aos locatários o que seu espaço tem para oferecer:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xff4300B1),
                  ),
                ),
                const SizedBox(
                  height: 19,
                ),
                ServicesPanel(
                  text:
                      'Você pode editar os serviços mesmo após publicar, adicionando ou removendo comodidades.\n\nSelecione os serviços do espaço:',
                  onServicePressed: (value) {
                    log('onServicePressed: $value');
                    newSpaceRegister.addOrRemoveService(value);
                  },
                  selectedServices: const [],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 69, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
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
            const SizedBox(
              height: 9,
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdicioneFotos(),
                ),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
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
                  'Avançar',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     leading: Padding(
    //       padding: const EdgeInsets.only(left: 18.0),
    //       child: Container(
    //         decoration: BoxDecoration(
    //           //color: Colors.white.withOpacity(0.7),
    //           color: Colors.white,
    //           shape: BoxShape.circle,
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.grey.withOpacity(0.5),
    //               spreadRadius: 2,
    //               blurRadius: 5,
    //               offset: const Offset(0, 2),
    //             ),
    //           ],
    //         ),
    //         child: InkWell(
    //           onTap: () => Navigator.of(context).pop(),
    //           child: const Icon(
    //             Icons.arrow_back,
    //             color: Colors.black,
    //           ),
    //         ),
    //       ),
    //     ),
    //     centerTitle: true,
    //     title: const Text(
    //       'Cadastro de espaço',
    //       style: TextStyle(
    //           fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    //     ),
    //     elevation: 0,
    //     backgroundColor: Colors.white,
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             const Text(
    //               'Informe aos hospedes o que seu espaço tem pra oferecer',
    //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    //             ),
    //             const Text(
    //                 'voce pode adicionar mais comodidades depois de publicar'),
    //             ServicesPanel(
    //               text: 'Selecione os SERVIÇOS do espaço',
    //               onServicePressed: (value) {
    //                 log('onServicePressed: $value');
    //                 newSpaceRegister.addOrRemoveService(value);
    //               },
    //               selectedServices: const [],
    //             ),
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 20,
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.all(15.0),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               InkWell(
    //                 onTap: () => Navigator.pop(context),
    //                 child: const Text(
    //                   'Voltar',
    //                   style: TextStyle(
    //                     decoration: TextDecoration.underline,
    //                   ),
    //                 ),
    //               ),
    //               InkWell(
    //                 onTap: () => Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                     builder: (context) => const AdicioneFotos(),
    //                   ),
    //                 ),
    //                 child: Container(
    //                   decoration: BoxDecoration(
    //                       color: Colors.black,
    //                       border: Border.all(),
    //                       borderRadius: BorderRadius.circular(10)),
    //                   padding: const EdgeInsets.symmetric(
    //                       horizontal: 15, vertical: 10),
    //                   child: const Text(
    //                     'Avançar',
    //                     style: TextStyle(color: Colors.white),
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
