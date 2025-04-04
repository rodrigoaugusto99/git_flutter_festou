import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festou/src/features/register/space/space%20temporary/pages/adicione_fotos.dart';
import 'package:festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';

import 'package:festou/src/features/register/space/widgets/services_panel.dart';
import 'package:festou/src/helpers/keys.dart';

class ServicosComodidades extends ConsumerStatefulWidget {
  const ServicosComodidades({super.key});

  @override
  ConsumerState<ServicosComodidades> createState() =>
      _ServicosAcomodacoesState();
}

class _ServicosAcomodacoesState extends ConsumerState<ServicosComodidades> {
  @override
  void initState() {
    super.initState();
    final vm = ref.read(newSpaceRegisterVmProvider.notifier);
    final state = vm.getState();
    selected = state.selectedServices;
  }

  List<String> selected = [];
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
        child: SingleChildScrollView(
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
                    selectedServices: selected,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38.0, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              key: Keys.k4ScreenButton,
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
            const SizedBox(
              height: 9,
            ),
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
          ],
        ),
      ),
    );
  }
}
