import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/adicione_fotos.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';

import 'package:git_flutter_festou/src/features/register/space/widgets/services_panel.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      'Salvar e sair',
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      'Dúvidas?',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informe aos hospedes o que seu espaço tem pra oferecer',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Text(
                  'voce pode adicionar mais comodidades depois de publicar'),
              ServicesPanel(
                text: 'Selecione os SERVIÇOS do espaço',
                onServicePressed: (value) {
                  log('onServicePressed: $value');
                  newSpaceRegister.addOrRemoveService(value);
                },
                selectedServices: const [],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Voltar',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdicioneFotos(),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: const Text(
                      'Avançar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
