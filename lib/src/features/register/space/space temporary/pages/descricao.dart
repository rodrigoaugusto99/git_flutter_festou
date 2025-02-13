import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festou/src/core/ui/helpers/messages.dart';
import 'package:festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';
import 'package:festou/src/features/register/space/space%20temporary/pages/preco.dart';
import 'package:festou/src/features/register/space/space%20temporary/pages/textfield.dart';
import 'package:festou/src/helpers/keys.dart';

class Descricao extends ConsumerStatefulWidget {
  const Descricao({super.key});

  @override
  ConsumerState<Descricao> createState() => _DescricaoState();
}

class _DescricaoState extends ConsumerState<Descricao> {
  @override
  void initState() {
    super.initState();
    final vm = ref.read(newSpaceRegisterVmProvider.notifier);
    final state = vm.getState();
    descricaoEC.text = state.descricao;
  }

  final descricaoEC = TextEditingController();
  final int maxLength = 2000;
  @override
  Widget build(BuildContext context) {
    final spaceRegister = ref.watch(newSpaceRegisterVmProvider.notifier);
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8F8F8),
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38.0, vertical: 20),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Crie sua descriação:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xff4300B1),
                  ),
                ),
                const SizedBox(
                  height: 19,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 27),
                  child: Text(
                    'Explique o que seu espaço tem de especial e encante os clientes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                myRow(
                  validator: spaceRegister.validateBairro(),
                  label: 'Descrição do espaço',
                  controller: descricaoEC,
                  maxLines: 10,
                  alwaysOnTop: true,
                  onChanged: (text) {
                    setState(() {
                      if (text.length > maxLength) {
                        // Limita o texto ao número máximo de caracteres
                        descricaoEC.text = text.substring(0, maxLength);
                      }
                    });
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Caracteres restantes: ${maxLength - descricaoEC.text.length}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
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
              key: Keys.k7ScreenButton,
              onTap: () {
                final result = spaceRegister.validateDescricao(
                  descricaoEC.text,
                );
                if (result) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Preco(),
                    ),
                  );
                } else {
                  Messages.showInfo('Escreva uma descrição', context);
                }
              },
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
