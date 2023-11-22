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
  TextEditingController nameEC = TextEditingController();
  TextEditingController telefoneEC = TextEditingController();
  TextEditingController emailEC = TextEditingController();
  bool isEditingName = false;
  bool isEditingTelefone = false;
  bool isEditinEmail = false;

  @override
  void initState() {
    super.initState();

    nameEC = TextEditingController(text: widget.userModel.name);
    telefoneEC = TextEditingController(text: widget.userModel.telefone);
    emailEC = TextEditingController(text: widget.userModel.email);
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
        ref.read(informacoesPessoaisVMProvider.notifier);

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

    //todo!: apenas atualiza no app se restartar
    //todo: vm - build {}, page .when, :loading em cada textfield quando atualizar?
    nameEC = TextEditingController(text: widget.userModel.name);
    telefoneEC = TextEditingController(text: widget.userModel.telefone);
    emailEC = TextEditingController(text: widget.userModel.email);

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
                isEditingName = !isEditingName;
              }),
              child: MyRow(
                label: 'Nome civil',
                controller: nameEC,
                isEditing: isEditingName,
                onSave: (value) async {
                  log('Salvar: $value no campo nome');
                  if (isEditingName == true) {
                    await informacoesPessoaisVm.updateInfo('nome', value);
                    //nameEC.text = await informacoesPessoaisVm.getInfo('nome');
                    isEditingName = !isEditingName;
                  } else {
                    isEditingName = !isEditingName;
                  }

                  setState(() {
                    nameEC.text = value;
                  });
                },
              ),
            ),
            InkWell(
              onTap: () => setState(() {
                isEditingTelefone = !isEditingTelefone;
              }),
              child: MyRow(
                label: 'Telefone',
                controller: telefoneEC,
                isEditing: isEditingTelefone,
                onSave: (value) async {
                  log('Salvar: $value no campo telefone');
                  if (isEditingTelefone == true) {
                    await informacoesPessoaisVm.updateInfo('telefone', value);
                    isEditingTelefone = !isEditingTelefone;
                  } else {
                    isEditingTelefone = !isEditingTelefone;
                  }

                  setState(() {
                    telefoneEC.text = value;
                  });
                },
              ),
            ),
            InkWell(
              onTap: () => setState(() {
                isEditinEmail = !isEditinEmail;
              }),
              child: MyRow(
                label: 'E-mail',
                controller: emailEC,
                isEditing: isEditinEmail,
                onSave: (value) async {
                  log('Salvar: $value no campo email');
                  if (isEditinEmail == true) {
                    await informacoesPessoaisVm.updateInfo('email', value);
                    isEditinEmail = !isEditinEmail;
                  } else {
                    isEditinEmail = !isEditinEmail;
                  }

                  setState(() {
                    emailEC.text = value;
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
