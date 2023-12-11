import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/informa%C3%A7%C3%B5es%20pessoais/image_grid.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/informa%C3%A7%C3%B5es%20pessoais/informacoes_pessoais_status.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/informa%C3%A7%C3%B5es%20pessoais/informacoes_pessoais_vm.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:git_flutter_festou/src/models/user_with_images.dart';
import 'package:image_picker/image_picker.dart';

class InformacoesPessoais extends ConsumerStatefulWidget {
  final UserWithImages userWithImages;
  const InformacoesPessoais({super.key, required this.userWithImages});

  @override
  ConsumerState<InformacoesPessoais> createState() =>
      _InformacoesPessoaisState();
}

class _InformacoesPessoaisState extends ConsumerState<InformacoesPessoais> {
  TextEditingController nameEC = TextEditingController();
  TextEditingController telefoneEC = TextEditingController();
  TextEditingController emailEC = TextEditingController();
  TextEditingController cepEC = TextEditingController();
  TextEditingController logradourolEC = TextEditingController();
  TextEditingController bairroEC = TextEditingController();
  TextEditingController cidadeEC = TextEditingController();

  bool isEditingName = false;
  bool isEditingTelefone = false;
  bool isEditinEmail = false;
  bool isEditingCep = false;
  bool isEditingLogradouro = false;
  bool isEditingBairro = false;
  bool isEditingCidade = false;

  @override
  void initState() {
    super.initState();

    nameEC = TextEditingController(text: widget.userWithImages.user.name);
    telefoneEC =
        TextEditingController(text: widget.userWithImages.user.telefone);
    emailEC = TextEditingController(text: widget.userWithImages.user.email);
    cepEC = TextEditingController(text: widget.userWithImages.user.cep);
    logradourolEC =
        TextEditingController(text: widget.userWithImages.user.logradouro);
    bairroEC = TextEditingController(text: widget.userWithImages.user.bairro);
    cidadeEC = TextEditingController(text: widget.userWithImages.user.cidade);
  }

  @override
  void dispose() {
    nameEC.dispose();
    telefoneEC.dispose();
    emailEC.dispose();
    cepEC.dispose();
    logradourolEC.dispose();
    bairroEC.dispose();
    cidadeEC.dispose();

    super.dispose();
  }

  void verFotos(List<String> fotos) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Todas as fotos'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300, // Ajuste conforme necessário
            child: ListView.builder(
              itemCount: fotos.length,
              itemBuilder: (BuildContext context, int index) {
                // Aqui você pode personalizar a exibição da imagem.
                // Por exemplo, usando a classe Image.network para exibir imagens da web.
                return Image.network(
                  fotos[index],
                  fit: BoxFit.cover, // Ajuste conforme necessário
                );
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
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
          Messages.showSuccess('Alterado com sucesso!', context);
        case InformacoesPessoaisState(
            status: InformacoesPessoaisStateStatus.error,
            :final errorMessage?
          ):
          Messages.showError(errorMessage, context);
        case InformacoesPessoaisState(
            status: InformacoesPessoaisStateStatus.error
          ):
          Messages.showError('Erro ao alterar info', context);
      }
    });

    //todo!: apenas atualiza no app se restartar
    //todo: vm - build {}, page .when, :loading em cada textfield quando atualizar?

    return Scaffold(
      appBar: AppBar(
        title: const Text('x'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                child: myRow(
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
                child: myRow(
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
                child: myRow(
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

              //endereço

              InkWell(
                onTap: () => setState(() {
                  isEditingCep = !isEditingCep;
                }),
                child: myRow(
                  label: 'CEP',
                  controller: cepEC,
                  isEditing: isEditingCep,
                  onSave: (value) async {
                    log('Salvar: $value no campo cep');
                    if (isEditingCep == true) {
                      await informacoesPessoaisVm.updateInfo('cep', value);
                      //nameEC.text = await informacoesPessoaisVm.getInfo('nome');
                      isEditingCep = !isEditingCep;
                    } else {
                      isEditingCep = !isEditingCep;
                    }

                    setState(() {
                      cepEC.text = value;
                    });
                  },
                ),
              ),

              InkWell(
                onTap: () => setState(() {
                  isEditingLogradouro = !isEditingLogradouro;
                }),
                child: myRow(
                  label: 'Logradouro',
                  controller: logradourolEC,
                  isEditing: isEditingLogradouro,
                  onSave: (value) async {
                    log('Salvar: $value no campo Logradouro');
                    if (isEditingLogradouro == true) {
                      await informacoesPessoaisVm.updateInfo(
                          'logradouro', value);
                      //nameEC.text = await informacoesPessoaisVm.getInfo('nome');
                      isEditingLogradouro = !isEditingLogradouro;
                    } else {
                      isEditingLogradouro = !isEditingLogradouro;
                    }

                    setState(() {
                      logradourolEC.text = value;
                    });
                  },
                ),
              ),
              InkWell(
                onTap: () => setState(() {
                  isEditingBairro = !isEditingBairro;
                }),
                child: myRow(
                  label: 'Bairro',
                  controller: bairroEC,
                  isEditing: isEditingBairro,
                  onSave: (value) async {
                    log('Salvar: $value no campo bairro');
                    if (isEditingBairro == true) {
                      await informacoesPessoaisVm.updateInfo('bairro', value);
                      //nameEC.text = await informacoesPessoaisVm.getInfo('nome');
                      isEditingBairro = !isEditingBairro;
                    } else {
                      isEditingBairro = !isEditingBairro;
                    }

                    setState(() {
                      bairroEC.text = value;
                    });
                  },
                ),
              ),
              InkWell(
                onTap: () => setState(() {
                  isEditingCidade = !isEditingCidade;
                }),
                child: myRow(
                  label: 'Cidade',
                  controller: cidadeEC,
                  isEditing: isEditingCidade,
                  onSave: (value) async {
                    log('Salvar: $value no campo cidade');
                    if (isEditingCidade == true) {
                      await informacoesPessoaisVm.updateInfo('cidade', value);
                      //nameEC.text = await informacoesPessoaisVm.getInfo('nome');
                      isEditingCidade = !isEditingCidade;
                    } else {
                      isEditingCidade = !isEditingCidade;
                    }

                    setState(() {
                      cidadeEC.text = value;
                    });
                  },
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => informacoesPessoaisVm.pickImage(),
                    child: const Text('upload photo'),
                  ),
                  ElevatedButton(
                    onPressed: () => informacoesPessoaisVm
                        .uploadNewImages(widget.userWithImages.user.id),
                    child: const Text('salvar'),
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: () {
                  verFotos(widget.userWithImages.imageUrls);
                },
                child: const Text('Ver documentos teste 2'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myRow({
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
