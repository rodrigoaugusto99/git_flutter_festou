import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:festou/src/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festou/src/core/ui/helpers/messages.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/informa%C3%A7%C3%B5es%20pessoais/informacoes_pessoais_status.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/informa%C3%A7%C3%B5es%20pessoais/informacoes_pessoais_vm.dart';
import 'package:festou/src/features/loading_indicator.dart';
import 'package:festou/src/models/user_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:search_cep/search_cep.dart';

class InformacoesPessoais extends ConsumerStatefulWidget {
  const InformacoesPessoais({super.key});

  @override
  ConsumerState<InformacoesPessoais> createState() =>
      _InformacoesPessoaisState();
}

class _InformacoesPessoaisState extends ConsumerState<InformacoesPessoais> {
  TextEditingController fantasyNameEC = TextEditingController();
  TextEditingController nameEC = TextEditingController();
  TextEditingController telefoneEC = TextEditingController();
  TextEditingController emailEC = TextEditingController();
  TextEditingController cepEC = TextEditingController();
  TextEditingController logradourolEC = TextEditingController();
  TextEditingController bairroEC = TextEditingController();
  TextEditingController numeroEC = TextEditingController();
  TextEditingController cidadeEC = TextEditingController();
  TextEditingController cpfEC = TextEditingController();

  File? _selectedImage;
  bool isEditing = false;
  bool isLoading = false;
  bool isHovering = false;
  String buttonEditionName = 'Editar';
  String avatarUrl = '';
  String originalAvatarUrl = '';
  bool isImageRemoved = false;
  late Map<String, dynamic> userData;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    userModel = await UserService().getCurrentUserModel();
    fantasyNameEC = TextEditingController(text: userModel!.fantasyName);
    nameEC = TextEditingController(text: userModel!.name);
    cpfEC = TextEditingController(text: userModel!.cpf);
    emailEC = TextEditingController(text: userModel!.email);
    telefoneEC = TextEditingController(text: userModel!.telefone);
    cepEC = TextEditingController(text: userModel!.cep);
    logradourolEC = TextEditingController(text: userModel!.logradouro);
    numeroEC = TextEditingController(text: userModel!.numero);
    bairroEC = TextEditingController(text: userModel!.bairro);
    cidadeEC = TextEditingController(text: userModel!.cidade);
    avatarUrl = userModel!.avatarUrl;
    originalAvatarUrl = avatarUrl;
    setState(() {});
  }

  Future<void> onChangeCep(String value) async {
    if (value.length != 9) return;
    final viaCepSearchCep = ViaCepSearchCep();
    final infoCepJSON =
        await viaCepSearchCep.searchInfoByCep(cep: value.replaceAll('-', ''));
    infoCepJSON.fold(
      (error) {
        log('Erro ao buscar informações do CEP: $error');
      },
      (infoCepJSON) async {
        logradourolEC.text = infoCepJSON.logradouro ?? '';
        bairroEC.text = infoCepJSON.bairro ?? '';
        cidadeEC.text = infoCepJSON.localidade ?? '';
        // uf = infoCepJSON.uf ?? '';
        // estadoEC.text = infoCepJSON.uf ?? '';
        //isCepAutoCompleted = true;
        //await Future.delayed(const Duration(milliseconds: 1000));
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    fantasyNameEC.dispose();
    nameEC.dispose();
    cpfEC.dispose();
    emailEC.dispose();
    telefoneEC.dispose();
    cepEC.dispose();
    logradourolEC.dispose();
    numeroEC.dispose();
    bairroEC.dispose();
    cidadeEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final informacoesPessoaisVm =
        ref.watch(informacoesPessoaisVMProvider.notifier);

    ref.listen(informacoesPessoaisVMProvider, (_, state) {
      switch (state.status) {
        case InformacoesPessoaisStateStatus.success:
          break;
        case InformacoesPessoaisStateStatus.error:
          if (state.errorMessage != null) {
            Messages.showError(state.errorMessage!, context);
          }
          break;
        default:
          break;
      }
    });

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 247, 247),
      appBar: AppBar(
        surfaceTintColor: const Color(0xfff8f8f8),
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Container(
            decoration: BoxDecoration(
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
          'Informações pessoais',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: const Color(0xfff8f8f8),
      ),
      body: userModel == null || isLoading
          ? const CustomLoadingIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(17.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('uid', isEqualTo: userModel!.uid)
                            .limit(1)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CustomLoadingIndicator();
                          }

                          if (snapshot.hasError) {
                            return Text('Erro: ${snapshot.error}');
                          }
                          if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            Map<String, dynamic> userData =
                                snapshot.data!.docs[0].data()
                                    as Map<String, dynamic>;
                            String avatarUrl = userData['avatar_url'] ?? '';
                            return InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 30.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (isEditing) {
                                              final newAvatar =
                                                  await informacoesPessoaisVm
                                                      .pickAvatar();
                                              if (newAvatar != null) {
                                                setState(() {
                                                  _selectedImage = newAvatar;
                                                });
                                              }
                                            }
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                _selectedImage != null
                                                    ? CircleAvatar(
                                                        backgroundImage:
                                                            FileImage(
                                                                _selectedImage!),
                                                        radius: 60,
                                                      )
                                                    : avatarUrl.isNotEmpty &&
                                                            !isImageRemoved
                                                        ? CircleAvatar(
                                                            backgroundImage:
                                                                Image.network(
                                                              avatarUrl,
                                                              fit: BoxFit.cover,
                                                            ).image,
                                                            radius: 60,
                                                          )
                                                        : CircleAvatar(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xffeaddff),
                                                            radius: 60,
                                                            child: userModel!
                                                                    .name
                                                                    .isNotEmpty
                                                                ? Text(
                                                                    userModel!
                                                                        .name[0],
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            52),
                                                                  )
                                                                : const Icon(
                                                                    Icons
                                                                        .person,
                                                                    size: 40,
                                                                  ),
                                                          ),
                                                if (isEditing)
                                                  Positioned.fill(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                if (isEditing)
                                                  const Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (isEditing &&
                                              avatarUrl.isNotEmpty &&
                                              !isImageRemoved ||
                                          isEditing && _selectedImage != null)
                                        Positioned(
                                          right: 5,
                                          child: GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                _selectedImage = null;
                                                avatarUrl = '';
                                                isImageRemoved = true;
                                              });
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const Text('Nenhum documento encontrado.');
                          }
                        }),
                    if (userModel!.locador)
                      myRow(
                        label: 'Nome Fantasia',
                        controller: fantasyNameEC,
                        enable: isEditing,
                      ),
                    myRow(
                      label:
                          userModel!.locador ? 'Nome / Razão Social' : 'Nome',
                      controller: nameEC,
                      enable: isEditing,
                    ),
                    myRow(
                      inputFormatters: [
                        TextInputMask(
                            mask: ['999.999.999-99', '99.999.999/9999-99'],
                            reverse: false)
                      ],
                      label: 'CPF / CNPJ',
                      controller: cpfEC,
                      enable: (isGoogleProvider() ||
                          (cpfEC.text.isEmpty && isEditing)),
                    ),
                    myRow(
                      label: 'E-mail',
                      controller: emailEC,
                      enable: false,
                    ),
                    myRow(
                      inputFormatters: [
                        MaskTextInputFormatter(
                          mask: '(##)#####-####',
                          filter: {"#": RegExp(r'[0-9]')},
                        )
                      ],
                      label: 'Telefone',
                      controller: telefoneEC,
                      enable: isEditing,
                    ),
                    myRow(
                      inputFormatters: [
                        MaskTextInputFormatter(
                          mask: '#####-###',
                          filter: {"#": RegExp(r'[0-9]')},
                        )
                      ],
                      onChanged: onChangeCep,
                      label: 'CEP',
                      controller: cepEC,
                      enable: isEditing,
                    ),
                    myRow(
                      label: 'Logradouro',
                      controller: logradourolEC,
                      enable: isEditing,
                    ),
                    myRow(
                      label: 'Número',
                      controller: numeroEC,
                      enable: isEditing,
                    ),
                    myRow(
                      label: 'Bairro',
                      controller: bairroEC,
                      enable: isEditing,
                    ),
                    myRow(
                      label: 'Cidade',
                      controller: cidadeEC,
                      enable: isEditing,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (isEditing) {
                          // Se estiver no modo edição, salva os dados e sai do modo de edição
                          setState(() {
                            isLoading = true;
                          });

                          bool saveImageSuccess = false;

                          await informacoesPessoaisVm.updateInfo(
                            fantasyName: fantasyNameEC.text,
                            bairro: bairroEC.text,
                            name: nameEC.text,
                            cep: cepEC.text,
                            telefone: telefoneEC.text,
                            logradouro: logradourolEC.text,
                            numero: numeroEC.text,
                            cidade: cidadeEC.text,
                            email: emailEC.text,
                            cpf: cpfEC.text,
                          );

                          if (isImageRemoved) {
                            await informacoesPessoaisVm.deleteImageFirestore(
                              'avatar_url',
                              userModel!.uid,
                            );
                            isImageRemoved = false;
                          }

                          if (_selectedImage != null) {
                            saveImageSuccess = await informacoesPessoaisVm
                                .uploadAvatar(userModel!.uid);

                            if (saveImageSuccess) {
                              Messages.showSuccess(
                                  'Dados salvos com sucesso', context);
                            } else {
                              Messages.showError(
                                  'Erro ao salvar dados', context);
                            }
                          } else {
                            Messages.showSuccess(
                                'Dados salvos com sucesso', context);
                          }

                          setState(() {
                            isLoading = false;
                            isEditing = false;
                            buttonEditionName = 'Editar';
                          });
                        } else {
                          // Se não estiver no modo edição, entra no modo edição
                          setState(() {
                            isEditing = true;
                            buttonEditionName = 'Salvar';
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 30, left: 30, top: 30, bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff9747FF),
                                Color(0xff4300B1),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            buttonEditionName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (isEditing) {
                          // Se estiver editando, "Cancelar" restaura os valores originais
                          setState(() {
                            fantasyNameEC.text = userModel!.fantasyName;
                            nameEC.text = userModel!.name;
                            telefoneEC.text = userModel!.telefone;
                            cepEC.text = userModel!.cep;
                            logradourolEC.text = userModel!.logradouro;
                            numeroEC.text = userModel!.numero;
                            bairroEC.text = userModel!.bairro;
                            cidadeEC.text = userModel!.cidade;
                            _selectedImage = null;
                            avatarUrl = originalAvatarUrl;
                            isEditing = false;
                            buttonEditionName = 'Editar';
                          });
                        } else {
                          // Se não estiver editando, volta para a tela anterior
                          Navigator.of(context).pop();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 30, right: 30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff9747FF),
                                Color(0xff4300B1),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            isEditing ? 'Cancelar' : 'Voltar',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  bool isGoogleProvider() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (var provider in user.providerData) {
        if (provider.providerId == 'google.com') {
          return true;
        }
      }
    }
    return false;
  }

  Widget myRow({
    required String label,
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatters,
    bool enable = true,
    final Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: TextFormField(
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          textInputAction: TextInputAction.done,
          enabled: enable,
          controller: controller,
          style: TextStyle(
              fontSize: 15,
              color: enable ? Colors.black : Colors.grey,
              overflow: TextOverflow.ellipsis),
          decoration: InputDecoration(
            labelStyle: const TextStyle(color: Colors.black, fontSize: 15),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 5.0,
            ),
            label: Text(label),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
