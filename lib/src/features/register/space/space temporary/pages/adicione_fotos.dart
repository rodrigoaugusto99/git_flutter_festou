import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/titulo.dart';
import 'package:git_flutter_festou/src/features/register/space/space_register_vm.dart';

class AdicioneFotos extends ConsumerStatefulWidget {
  const AdicioneFotos({super.key});

  @override
  ConsumerState<AdicioneFotos> createState() => _AdicioneFotosState();
}

class _AdicioneFotosState extends ConsumerState<AdicioneFotos> {
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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adicione algumas fotos da sua acomodaçao((tipo de espaço))',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                    'voce precisara de cinco fotos para começar. voce pode adicionar outras imagens ou faer alterações mais tarde.'),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => spaceRegister.pickImage(),
                child: const Text('Adicionar fotos')),
            ElevatedButton(
                onPressed: () {}, child: const Text('Tirar novas fotos')),
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
                        builder: (context) => const Titulo(),
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
      ),
    );
  }
}
