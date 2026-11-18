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

  static const _bg = Color(0xFFFAF7FC);
  static const _ink = Color(0xFF1C1426);
  static const _muted = Color(0xFF8A8096);
  static const _accent = Color(0xFF7C3AED);

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
      backgroundColor: _bg,
      body: SafeArea(
        child: userModel == null || isLoading
            ? const Center(child: CustomLoadingIndicator())
            : Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildAvatarSection(informacoesPessoaisVm),
                          const SizedBox(height: 8),
                          _sectionTitle('Dados pessoais'),
                          const SizedBox(height: 10),
                          if (userModel!.locador)
                            myRow(
                              label: 'Nome Fantasia',
                              controller: fantasyNameEC,
                              enable: isEditing,
                            ),
                          myRow(
                            label: userModel!.locador
                                ? 'Nome / Razão Social'
                                : 'Nome',
                            controller: nameEC,
                            enable: isEditing,
                          ),
                          myRow(
                            inputFormatters: [
                              TextInputMask(
                                mask: [
                                  '999.999.999-99',
                                  '99.999.999/9999-99',
                                ],
                                reverse: false,
                              )
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
                          const SizedBox(height: 14),
                          _sectionTitle('Endereço'),
                          const SizedBox(height: 10),
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
                          const SizedBox(height: 22),
                          _primaryButton(
                            label: buttonEditionName,
                            onTap: () async {
                              if (isEditing) {
                                setState(() => isLoading = true);

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
                                  await informacoesPessoaisVm
                                      .deleteImageFirestore(
                                    'avatar_url',
                                    userModel!.uid,
                                  );
                                  isImageRemoved = false;
                                }

                                if (_selectedImage != null) {
                                  final saveImageSuccess =
                                      await informacoesPessoaisVm
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
                                setState(() {
                                  isEditing = true;
                                  buttonEditionName = 'Salvar';
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          _secondaryButton(
                            label: isEditing ? 'Cancelar' : 'Voltar',
                            onTap: () {
                              if (isEditing) {
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
                                  isImageRemoved = false;
                                  isEditing = false;
                                  buttonEditionName = 'Editar';
                                });
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.of(context).pop(),
              child: Ink(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE8DFF8)),
                  boxShadow: [
                    BoxShadow(
                      color: _accent.withOpacity(0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: _ink,
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informações pessoais',
                  style: TextStyle(
                    fontFamily: 'RedHatDisplay',
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    letterSpacing: -0.4,
                    color: _ink,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Atualize seus dados cadastrais',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: _muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'RedHatDisplay',
        fontWeight: FontWeight.w800,
        fontSize: 16,
        letterSpacing: -0.2,
        color: _ink,
      ),
    );
  }

  Widget _buildAvatarSection(dynamic informacoesPessoaisVm) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: userModel!.uid)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CustomLoadingIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('Nenhum documento encontrado.');
        }

        final userData =
            snapshot.data!.docs[0].data() as Map<String, dynamic>;
        final streamAvatarUrl = userData['avatar_url'] ?? '';
        final showPhoto = _selectedImage != null ||
            (streamAvatarUrl.isNotEmpty && !isImageRemoved);
        final initial =
            userModel!.name.isNotEmpty ? userModel!.name[0].toUpperCase() : '?';

        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (!isEditing) return;
                    final newAvatar =
                        await informacoesPessoaisVm.pickAvatar();
                    if (newAvatar != null) {
                      setState(() => _selectedImage = newAvatar);
                    }
                  },
                  child: Container(
                    width: 108,
                    height: 108,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF9747FF), Color(0xFF6100FF)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6100FF).withOpacity(0.22),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 46,
                            backgroundColor: const Color(0xFFF3EBFF),
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : (streamAvatarUrl.isNotEmpty &&
                                        !isImageRemoved)
                                    ? NetworkImage(streamAvatarUrl)
                                        as ImageProvider
                                    : null,
                            child: showPhoto
                                ? null
                                : Text(
                                    initial,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 34,
                                      fontWeight: FontWeight.w700,
                                      color: _accent,
                                    ),
                                  ),
                          ),
                          if (isEditing)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.42),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.photo_camera_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isEditing &&
                    ((_selectedImage != null) ||
                        (streamAvatarUrl.isNotEmpty && !isImageRemoved)))
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImage = null;
                          avatarUrl = '';
                          isImageRemoved = true;
                        });
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF4D6D),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _primaryButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF9747FF), Color(0xFF6100FF)],
            ),
            boxShadow: [
              BoxShadow(
                color: _accent.withOpacity(0.28),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _secondaryButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE0D0FF)),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: _accent,
              ),
            ),
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE8DFF8)),
          boxShadow: [
            BoxShadow(
              color: _accent.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          textInputAction: TextInputAction.done,
          enabled: enable,
          controller: controller,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: enable ? _ink : _muted,
            overflow: TextOverflow.ellipsis,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: enable ? _accent : _muted,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 14,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
