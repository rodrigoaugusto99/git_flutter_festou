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
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  onChanged: (text) {
                    setState(() {
                      if (text.length > maxLength) {
                        // Limita o texto ao número máximo de caracteres
                        tituloEC.text = text.substring(0, maxLength);
                      }
                    });
                  },
                  controller: tituloEC,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: InputDecoration(
                      hintText: 'Digite seu texto...',
                      counterText: '${tituloEC.text.length}/$maxLength',
                      errorText: tituloEC.text.length > 99 ? 'Já chega' : null),
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
                      final result =
                          spaceRegister.validateTitulo(tituloEC.text);
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
      ),
    );
  }
}
