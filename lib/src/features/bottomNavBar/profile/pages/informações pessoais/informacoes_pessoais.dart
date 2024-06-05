import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController cepEC = TextEditingController();
  TextEditingController logradourolEC = TextEditingController();
  TextEditingController bairroEC = TextEditingController();
  TextEditingController cidadeEC = TextEditingController();
  TextEditingController cpfEC = TextEditingController();

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
    cpfEC = TextEditingController(text: widget.userModel.cpfOuCnpj);
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
                  offset: const Offset(0, 2), // changes position of shadow
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
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    informacoesPessoaisVm.pickAvatar();
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle),
                                    child: avatarUrl.isNotEmpty
                                        ? CircleAvatar(
                                            backgroundImage: Image.network(
                                              avatarUrl,
                                              fit: BoxFit.cover,
                                            ).image,
                                            radius: 60,
                                          )
                                        : const Icon(
                                            Icons.person,
                                            size: 90,
                                          ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: GestureDetector(
                                      onTap: () async {
                                        informacoesPessoaisVm
                                            .deleteImageFirestore('avatar_url',
                                                widget.userModel.id);
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close),
                                      )),
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
              myRow(
                label: 'Nome civil',
                controller: nameEC,
              ),
              myRow(
                label: 'Telefone',
                controller: telefoneEC,
              ),
              myRow(
                label: 'E-mail',
                controller: emailEC,
              ),
              myRow(
                label: 'CEP',
                controller: cepEC,
              ),
              myRow(
                label: 'Logradouro',
                controller: logradourolEC,
              ),
              myRow(
                label: 'Bairro',
                controller: bairroEC,
              ),
              myRow(
                label: 'Cidade',
                controller: cidadeEC,
              ),
              myRow(
                enable: false,
                label: 'CPF',
                controller: cpfEC,
              ),
              GestureDetector(
                onTap: () async {
                  final bool2 = await informacoesPessoaisVm
                      .uploadAvatar(widget.userModel.id);

                  await informacoesPessoaisVm.updateInfo(
                    bairro: bairroEC.text,
                    name: nameEC.text,
                    cep: cepEC.text,
                    telefone: telefoneEC.text,
                    logradouro: logradourolEC.text,
                    cidade: cidadeEC.text,
                    email: emailEC.text,
                  );

                  if (bool2) {
                    Messages.showSuccess('Dados salvos com sucesso', context);
                  } else {
                    Messages.showError('Erro ao salvar dados', context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20, left: 30, right: 30, top: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: const Color(0xff9747FF),
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      'Salvar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12),
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

  Widget myRow({
    required String label,
    required TextEditingController controller,
    bool enable = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: TextFormField(
          textInputAction: TextInputAction.done,
          //onFieldSubmitted: onFieldSubmitted,
          enabled: enable,
          controller: controller,

          style: TextStyle(
              color: enable ? Colors.black : Colors.grey,
              overflow: TextOverflow.ellipsis),

          decoration: InputDecoration(
            labelStyle: const TextStyle(color: Colors.black),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 5.0,
            ),
            label: Text(label),
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Color(0xff48464C),
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
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
