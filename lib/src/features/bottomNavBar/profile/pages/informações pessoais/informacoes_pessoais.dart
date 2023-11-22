import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/informa%C3%A7%C3%B5es%20pessoais/informacoes_pessoais_status.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/informa%C3%A7%C3%B5es%20pessoais/informacoes_pessoais_vm.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';

class InformacoesPessoais extends ConsumerStatefulWidget {
  final UserModel userModel;
  const InformacoesPessoais({super.key, required this.userModel});

  @override
  ConsumerState<InformacoesPessoais> createState() =>
      _InformacoesPessoaisState();
}

class _InformacoesPessoaisState extends ConsumerState<InformacoesPessoais> {
  late TextEditingController nameEC;
  late TextEditingController telefoneEC;
  late TextEditingController emailEC;
  late bool isEditing1;
  late bool isEditing2;
  late bool isEditing3;

  @override
  void initState() {
    super.initState();

    // Inicializar controladores com base nos valores iniciais do userModel
    nameEC = TextEditingController(text: widget.userModel.name);
    telefoneEC = TextEditingController(text: widget.userModel.telefone);
    emailEC = TextEditingController(text: widget.userModel.email);

    // Definir valores iniciais para os bools de edição
    isEditing1 = false;
    isEditing2 = false;
    isEditing3 = false;
  }

  @override
  void dispose() {
    nameEC.dispose();
    telefoneEC.dispose();
    emailEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final informacoesPessoaisVm =
        ref.watch(informacoesPessoaisVMProvider.notifier);

//todo!: sempre retorna status.initial
//todo: averiguar ref.listen em caso de build do state com parametro(cast n)
    ref.listen(informacoesPessoaisVMProvider, (_, state) {
      switch (state) {
        case InformacoesPessoaisState(
            status: InformacoesPessoaisStateStatus.success
          ):
          Messages.showSuccess('Filtrado com sucesso!', context);
        case InformacoesPessoaisState(
            status: InformacoesPessoaisStateStatus.error
          ):
          Messages.showError('Erro ao filtrar espaços', context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('x'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          children: [
            const Text(
              'Informações pessoais',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: () => setState(() {
                isEditing1 = !isEditing1;
              }),
              child: MyRow(
                label: 'Nome civil',
                controller: nameEC,
                isEditing: isEditing1,
                onSave: (value) async {
                  log('Salvar: $value no campo nome');
                  await informacoesPessoaisVm.updateInfo('nome', value);
                  setState(() {
                    nameEC.text = value;
                    isEditing1 = !isEditing1;
                  });
                },
              ),
            ),
            InkWell(
              onTap: () => setState(() {
                isEditing2 = !isEditing2;
              }),
              child: MyRow(
                label: 'Telefone',
                controller: telefoneEC,
                isEditing: isEditing2,
                onSave: (value) async {
                  log('Salvar: $value no campo telefone');
                  await informacoesPessoaisVm.updateInfo('telefone', value);
                  setState(() {
                    telefoneEC.text = value;
                    isEditing2 = !isEditing2;
                  });
                },
              ),
            ),
            InkWell(
              onTap: () => setState(() {
                isEditing3 = !isEditing3;
              }),
              child: MyRow(
                label: 'E-mail',
                controller: emailEC,
                isEditing: isEditing3,
                onSave: (value) async {
                  log('Salvar: $value no campo email');
                  await informacoesPessoaisVm.updateInfo('email', value);
                  setState(() {
                    emailEC.text = value;
                    isEditing3 = !isEditing3;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget MyRow({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required ValueChanged<String> onSave,
  }) {
    String textButton = isEditing ? 'Salvar' : 'Editar';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                enabled: isEditing,
                decoration: InputDecoration(
                  labelText: label,
                ),
              )
            ],
          ),
        ),
        TextButton(
          onPressed: () => onSave(controller.text),
          child: Text(
            textButton,
            style: const TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
