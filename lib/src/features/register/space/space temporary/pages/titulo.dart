import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/descricao.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';

class Titulo extends ConsumerStatefulWidget {
  const Titulo({super.key});

  @override
  ConsumerState<Titulo> createState() => _TituloState();
}

class _TituloState extends ConsumerState<Titulo> {
  final tituloEC = TextEditingController();
  final int maxLength = 100;
  @override
  Widget build(BuildContext context) {
    final spaceRegister = ref.watch(newSpaceRegisterVmProvider.notifier);
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
                'Agora vamos dar um titulo ao seu espaço',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Text(
                  'titulos curtos funcionam melhor. nao se preocupe, voce podra fazer alteracoes depois'),
              TextField(
                controller: tituloEC,
                maxLines: null, // Permite várias linhas
                maxLength: maxLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                decoration: InputDecoration(
                    hintText: 'Digite seu texto...',
                    counterText: '${tituloEC.text.length}/$maxLength',
                    errorText: tituloEC.text.length > 99 ? 'Já chega' : null),
              ),
              TextField(
                controller: tituloEC,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Titulo do espaço',
                ),
                onChanged: (text) {
                  setState(() {
                    if (text.length > maxLength) {
                      // Limita o texto ao número máximo de caracteres
                      tituloEC.text = text.substring(0, maxLength);
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Caracteres restantes: ${maxLength - tituloEC.text.length}',
                style: const TextStyle(color: Colors.black),
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
                  onTap: () {
                    final result = spaceRegister.validateTitulo(tituloEC.text);
                    if (result) {
                      Messages.showSuccess('Belo titulo', context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Descricao(),
                        ),
                      );
                    } else {
                      Messages.showError('Insira o titulo', context);
                    }
                  },
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
