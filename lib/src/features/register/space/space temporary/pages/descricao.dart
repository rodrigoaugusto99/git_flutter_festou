import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/preco.dart';

class Descricao extends ConsumerStatefulWidget {
  const Descricao({super.key});

  @override
  ConsumerState<Descricao> createState() => _DescricaoState();
}

class _DescricaoState extends ConsumerState<Descricao> {
  final descricaoEC = TextEditingController();
  final int maxLength = 30;
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
                'Crie sua descricao',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Text('Explique o que sua acomodacao tem de especial'),
              TextField(
                controller: descricaoEC,
                maxLines: 5, // Número máximo de linhas visíveis
                minLines: 3, // Número mínimo de linhas visíveis
                decoration: const InputDecoration(
                  labelText: 'Descrição do espaço',
                ),
                onChanged: (text) {
                  setState(() {
                    if (text.length > maxLength) {
                      // Limita o texto ao número máximo de caracteres
                      descricaoEC.text = text.substring(0, maxLength);
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Caracteres restantes: ${maxLength - descricaoEC.text.length}',
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
                    final result =
                        spaceRegister.validateTitulo(descricaoEC.text);
                    if (result) {
                      Messages.showSuccess('Bela descricao', context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Preco(),
                        ),
                      );
                    } else {
                      Messages.showError('escreva  descrico', context);
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
