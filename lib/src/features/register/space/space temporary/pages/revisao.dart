import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';
import 'package:git_flutter_festou/src/features/register/space/space_register_state.dart';

class Revisao extends ConsumerStatefulWidget {
  const Revisao({super.key});

  @override
  ConsumerState<Revisao> createState() => _RevisaoState();
}

class _RevisaoState extends ConsumerState<Revisao> {
  @override
  Widget build(BuildContext context) {
    final newSpaceRegister = ref.watch(newSpaceRegisterVmProvider.notifier);

    ref.listen(newSpaceRegisterVmProvider, (_, state) {
      switch (state) {
        case SpaceRegisterState(status: SpaceRegisterStateStatus.initial):
          break;

        case SpaceRegisterState(status: SpaceRegisterStateStatus.success):
          Messages.showSuccess('parabens', context);

        case SpaceRegisterState(
            status: SpaceRegisterStateStatus.error,
            :final errorMessage?
          ):
          Messages.showError(errorMessage, context);
      }
    });
    final spaceRegisterState = ref.watch(newSpaceRegisterVmProvider);
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
            const SizedBox(
              height: 20,
            ),
            Text('Days: ${spaceRegisterState.days.toString()}'),
            Text(
                'Selected Services: ${spaceRegisterState.selectedServices.toString()}'),
            Text(
                'Selected Types: ${spaceRegisterState.selectedTypes.toString()}'),
            Text('Bairro: ${spaceRegisterState.bairro}'),
            Text('CEP: ${spaceRegisterState.cep}'),
            Text('Cidade: ${spaceRegisterState.cidade}'),
            Text('Descrição: ${spaceRegisterState.descricao}'),
            Text('Logradouro: ${spaceRegisterState.logradouro}'),
            Text('Número: ${spaceRegisterState.numero}'),
            Text('Preço: ${spaceRegisterState.preco}'),
            Text('Título: ${spaceRegisterState.titulo}'),
            Text('Start Time: ${spaceRegisterState.startTime}'),
            Text('End Time: ${spaceRegisterState.endTime}'),
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
                    onTap: () => newSpaceRegister.register(),
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
