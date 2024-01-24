import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/informa%C3%A7%C3%B5es%20pessoais/image_grid.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/informa%C3%A7%C3%B5es%20pessoais/informacoes_pessoais_status.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/informa%C3%A7%C3%B5es%20pessoais/informacoes_pessoais_vm.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

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

    nameEC = TextEditingController(text: widget.userModel.name);
    telefoneEC = TextEditingController(text: widget.userModel.telefone);
    emailEC = TextEditingController(text: widget.userModel.email);
    cepEC = TextEditingController(text: widget.userModel.cep);
    logradourolEC = TextEditingController(text: widget.userModel.logradouro);
    bairroEC = TextEditingController(text: widget.userModel.bairro);
    cidadeEC = TextEditingController(text: widget.userModel.cidade);
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

  @override
  Widget build(BuildContext context) {
    final informacoesPessoaisVm =
        ref.watch(informacoesPessoaisVMProvider.notifier);

    ref.listen(informacoesPessoaisVMProvider, (_, state) {
      switch (state) {
        case InformacoesPessoaisState(
            status: InformacoesPessoaisStateStatus.success
          ):
          break;

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
    //todo: vm - build {}, page .when, :loading em cada textfield quando atualizar? ou stream logo

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

              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('uid', isEqualTo: widget.userModel.id)
                      .limit(1)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Erro: ${snapshot.error}');
                    }
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      Map<String, dynamic> userData =
                          snapshot.data!.docs[0].data() as Map<String, dynamic>;
                      String avatarUrl = userData['avatar_url'] ?? '';

                      return InkWell(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Excluir avatar'),
                                content: const Text(
                                    'Tem certeza de que deseja excluir seu avatar?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Fecha o AlertDialog
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      informacoesPessoaisVm
                                          .deleteImageFirestore('avatar_url',
                                              widget.userModel.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Confirmar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onTap: () {
                          informacoesPessoaisVm.pickAvatar();
                        },
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: avatarUrl != ''
                              ? CircleAvatar(
                                  backgroundImage: Image.network(
                                    avatarUrl,
                                    fit: BoxFit.cover,
                                  ).image,
                                  radius: 100,
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 90,
                                ),
                        ),
                      );
                    } else {
                      return const Text('Nenhum documento encontrado.');
                    }
                  }),

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

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('uid', isEqualTo: widget.userModel.id)
                    .limit(1)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  }

                  // Verifique se há documentos disponíveis
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    // Obtenha os dados do primeiro documento encontrado
                    Map<String, dynamic> userData =
                        snapshot.data!.docs[0].data() as Map<String, dynamic>;
                    String doc1Url = userData['doc1_url'] ?? '';
                    String doc2Url = userData['doc2_url'] ?? '';

                    return Column(
                      children: [
                        InkWell(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Excluir imagem'),
                                  content: const Text(
                                      'Tem certeza de que deseja excluir esta imagem?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Fecha o AlertDialog
                                      },
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Exclui a imagem se o usuário clicar em "Confirmar"
                                        informacoesPessoaisVm.deleteImage(
                                            widget.userModel.id, 0);
                                        informacoesPessoaisVm
                                            .deleteImageFirestore('doc1_url',
                                                widget.userModel.id);
                                        Navigator.of(context)
                                            .pop(); // Fecha o AlertDialog
                                      },
                                      child: const Text('Confirmar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onTap: () => informacoesPessoaisVm.pickImage1(),
                          child: SizedBox(
                            height: 200,
                            child: doc1Url != ''
                                ? Image.network(
                                    doc1Url,
                                    fit: BoxFit
                                        .cover, // Ajuste conforme necessário
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    height: 200,
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Adicionar uma imagem'),
                                        Icon(
                                          Icons.photo_outlined,
                                          size: 40,
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        InkWell(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Excluir imagem'),
                                  content: const Text(
                                      'Tem certeza de que deseja excluir esta imagem?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Fecha o AlertDialog
                                      },
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Exclui a imagem se o usuário clicar em "Confirmar"
                                        informacoesPessoaisVm.deleteImage(
                                            widget.userModel.id, 1);
                                        informacoesPessoaisVm
                                            .deleteImageFirestore('doc2_url',
                                                widget.userModel.id);
                                        Navigator.of(context)
                                            .pop(); // Fecha o AlertDialog
                                      },
                                      child: const Text('Confirmar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onTap: () => informacoesPessoaisVm.pickImage2(),
                          child: SizedBox(
                            height: 200,
                            child: doc2Url != ''
                                ? Image.network(
                                    doc2Url,
                                    fit: BoxFit
                                        .cover, // Ajuste conforme necessário
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    height: 200,
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Adicionar uma imagem'),
                                        Icon(
                                          Icons.photo_outlined,
                                          size: 40,
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text('Nenhum documento encontrado.');
                  }
                },
              ),

              /*InkWell(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Excluir imagem'),
                        content: const Text(
                            'Tem certeza de que deseja excluir esta imagem?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Fecha o AlertDialog
                            },
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Exclui a imagem se o usuário clicar em "Confirmar"
                              informacoesPessoaisVm.deleteImage(
                                  widget.userModel.id, 1);
                              Navigator.of(context)
                                  .pop(); // Fecha o AlertDialog
                            },
                            child: const Text('Confirmar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                onTap: () => informacoesPessoaisVm.pickImage2(),
                child: SizedBox(
                  height: 200,
                  child: widget.userModel.doc2Url != ''
                      ? Image.network(
                          widget.userModel.doc2Url,
                          fit: BoxFit.cover, // Ajuste conforme necessário
                        )
                      : Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(border: Border.all()),
                          height: 200,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Adicionar uma imagem'),
                              Icon(
                                Icons.photo_outlined,
                                size: 40,
                              ),
                            ],
                          ),
                        ),
                ),
              ),*/

              ElevatedButton(
                onPressed: () async {
                  final bool1 = await informacoesPessoaisVm
                      .uploadNewImages(widget.userModel.id);
                  final bool2 = await informacoesPessoaisVm
                      .uploadAvatar(widget.userModel.id);

                  if (bool1 && bool2) {
                    Messages.showSuccess('Dados salvos com sucesso', context);
                  } else if (!bool1 && bool2) {
                    Messages.showError('erro ao salvar documentos', context);
                  } else if (!bool2 && bool1) {
                    Messages.showError('erro ao salvar avatar', context);
                  } else {
                    Messages.showError('erro ao salvar dados', context);
                  }
                },
                child: const Text('salvar'),
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
