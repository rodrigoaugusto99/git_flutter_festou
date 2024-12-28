import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/login%20e%20seguran%C3%A7a/esqueci_senha.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/login%20e%20seguran%C3%A7a/widget/passwordField.dart';
import 'package:git_flutter_festou/src/services/auth_services.dart';

class LoginSeguranca extends ConsumerStatefulWidget {
  const LoginSeguranca({super.key});

  @override
  ConsumerState<LoginSeguranca> createState() => _LoginSegurancaState();
}

class _LoginSegurancaState extends ConsumerState<LoginSeguranca>
    with WidgetsBindingObserver {
  final TextEditingController novaSenhaController = TextEditingController();
  final TextEditingController confirmarSenhaController =
      TextEditingController();
  final TextEditingController senhaAtualController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void initState() {
    // Adiciona o observer para monitorar mudanças de ciclo de vida do widget
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    novaSenhaController.dispose();
    confirmarSenhaController.dispose();
    // Remove o observer ao destruir o widget
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Este bloco de código será executado depois da construção completa da árvore de widgets.

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Este bloco de código será executado após a construção completa da árvore de widgets.

      yourFunctionToBeCalled();
      displayAuthProviderList();
      showUserProvider();
      setState(() {});
    });
  }

  void yourFunctionToBeCalled() {
    // Faça algo aqui
    log("\nTela completamente construída!");
  }

  bool isUpdatingPassword = false;

  List<String> providers = [];

  Future<void> displayAuthProviderList() async {
    try {
      // Obtenha o usuário atualmente autenticado
      final user = FirebaseAuth.instance.currentUser!;
      providers = [];

      // Obtém a lista de provedores associados ao usuário

      for (UserInfo userInfo in user.providerData) {
        providers.add(userInfo.providerId);
      }

      // Exibe a lista de provedores
      log("\nProvedores associados ao usuário: $providers");
    } catch (e) {
      log("Erro ao obter a lista de provedores: $e");
    }
  }

  // Verifica se "google.com" está na lista de provedores
  // bool isGoogleConnected = providers.contains("google.com");
  Widget buildGoogleWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'lib/assets/images/google.png',
              width: 24, // Ajuste conforme necessário
              height: 24,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text("Google"),
          ],
        ),
        InkWell(
          onTap: () {},
          child: const Text(
            'Desvincular',
            style: TextStyle(
              color: Color(0XFF4300B1),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

//providerData para obter os detalhes do usuario autenticado.
  void showUserProvider() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      for (var profile in user.providerData) {
        log('\n---------DADOS DO USUARIO NO AUTH---------');
        log("Provider ID: ${profile.providerId}");
        log("uid: ${profile.uid}");
        log("Display Name: ${profile.displayName}");
        log("Email: ${profile.email}");
        log("Photo URL ID: ${profile.photoURL}");
      }
    } else {
      log("Usuário não autenticado");
    }
  }

  Future<void> areYouSureOnlyGoogle(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      log('Usuário não autenticado');
      return;
    }

    final providers = await user.providerData;
    if (providers.length == 1 && providers[0].providerId == "google.com") {
      // Exibe o diálogo de confirmação
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmação de Desvinculação'),
            content: const Text(
                'O Google é seu único provedor. Se você desvincular, precisará configurar uma senha para continuar acessando sua conta.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Fecha o diálogo de confirmação

                  // Abre o pop-up para cadastrar nova senha
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      final newPasswordController = TextEditingController();
                      final confirmPasswordController = TextEditingController();

                      return AlertDialog(
                        title: const Center(
                          child: Text(
                            'Cadastrar senha',
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                "Agora você deve cadastrar uma senha para login com e-mail:",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            TextField(
                              controller: newPasswordController,
                              decoration: const InputDecoration(
                                labelText: 'Nova senha',
                                labelStyle: TextStyle(fontSize: 14),
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: confirmPasswordController,
                              decoration: const InputDecoration(
                                labelText: 'Confirmar senha',
                                labelStyle: TextStyle(fontSize: 14),
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () async {
                              final newPassword =
                                  newPasswordController.text.trim();
                              final confirmPassword =
                                  confirmPasswordController.text.trim();

                              if (newPassword.isEmpty ||
                                  confirmPassword.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Os campos não podem estar vazios.'),
                                  ),
                                );
                                return;
                              }

                              if (newPassword.length < 6) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'A senha deve conter no mínimo 6 caracteres.'),
                                  ),
                                );
                                return;
                              }

                              if (newPassword != confirmPassword) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('As senhas não coincidem.'),
                                  ),
                                );
                                return;
                              }

                              try {
                                // Atualiza a senha do usuário
                                await user.updatePassword(newPassword);
                                await user.unlink("google.com");

                                setState(() {
                                  displayAuthProviderList();
                                });

                                Navigator.of(context)
                                    .pop(); // Fecha o pop-up de senha

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Senha cadastrada e Google desvinculado com sucesso!'),
                                  ),
                                );
                              } on FirebaseAuthException catch (e) {
                                log('Erro ao cadastrar senha: ${e.code}, ${e.message}');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Erro ao cadastrar senha: ${e.message}',
                                    ),
                                  ),
                                );
                              } catch (e) {
                                log('Erro desconhecido ao cadastrar senha: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Erro desconhecido ao cadastrar senha.'),
                                  ),
                                );
                              }
                            },
                            child: const Text('Cadastrar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Confirmar'),
              ),
            ],
          );
        },
      );
    } else {
      log('O usuário possui outros provedores ou nenhum.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 247, 247),
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
          'Login e segurança',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Login',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              MyRow(
                widget: Image.asset(
                  'lib/assets/images/IconPassword.png',
                  width: 26, // Ajuste conforme necessário
                  height: 26,
                ),
                subtitle: 'Senha',
                textButton: !isUpdatingPassword ? 'Atualizar' : 'Cancelar',
                onTap: () {
                  setState(() {
                    isUpdatingPassword = !isUpdatingPassword;
                  });
                },
              ),
              if (isUpdatingPassword) ...[
                Column(
                  key: const ValueKey('updatePasswordFields'),
                  children: [
                    if (providers.contains("password")) ...[
                      PasswordField(
                        controller: senhaAtualController,
                        label: 'Senha atual',
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const EsqueciSenha(),
                                    ),
                                  ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text('Esqueci minha senha'),
                              )),
                        ],
                      ),
                    ],
                    const SizedBox(height: 10),
                    PasswordField(
                      controller: novaSenhaController,
                      label: 'Nova Senha',
                    ),
                    PasswordField(
                      controller: confirmarSenhaController,
                      label: 'Confirmar Senha',
                    ),
                    const SizedBox(height: 0),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            try {
                              String novaSenha = novaSenhaController.text;
                              String confirmarSenha =
                                  confirmarSenhaController.text;
                              String senhaAtual = providers.contains("password")
                                  ? senhaAtualController.text
                                  : '';

                              if (novaSenha.isEmpty || confirmarSenha.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'As senhas não podem estar vazias.')),
                                );
                                return;
                              }

                              if (novaSenha != confirmarSenha) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('As senhas não coincidem.')),
                                );
                                return;
                              }

                              if (providers.contains("password")) {
                                // Reautentica o usuário com a nova senha
                                AuthCredential credential =
                                    EmailAuthProvider.credential(
                                  email: user.email!,
                                  password: senhaAtual,
                                );
                                await user
                                    .reauthenticateWithCredential(credential);
                              } else {
                                // Verifica se o Google está vinculado
                                await AuthService(context: context)
                                    .signInWithGoogle();
                              }

                              // Atualiza a senha do usuário
                              await user.updatePassword(novaSenha);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: providers.contains("password")
                                      ? const Text(
                                          'Senha atualizada com sucesso.')
                                      : const Text(
                                          'Senha cadastrada com sucesso.'),
                                ),
                              );

                              setState(() {
                                isUpdatingPassword = false;
                              });

                              // Recarregar a página atual
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        super.widget),
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('A senha é muito fraca.')),
                                );
                              } else if (e.code == 'requires-recent-login') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Reautenticação necessária. Faça login novamente.'),
                                  ),
                                );
                              } else {
                                log('Erro ao atualizar a senha: ${e.code}, ${e.message}');
                              }
                            } catch (e) {
                              log('Erro desconhecido ao atualizar a senha: $e');
                            }
                          }
                        },
                        child: providers.contains("password")
                            ? const Text('Alterar Senha')
                            : const Text('Cadastrar Senha'),
                      ),
                    ),
                  ],
                )
              ],
              const SizedBox(height: 30),
              const Text(
                'Contas sociais',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              providers.contains("google.com")
                  ? Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'lib/assets/images/google.png',
                                    width: 24, // Ajuste conforme necessário
                                    height: 24,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Google"),
                                ],
                              ),
                              InkWell(
                                onTap: () async {
                                  final user =
                                      FirebaseAuth.instance.currentUser;
                                  if (user != null) {
                                    try {
                                      // Verifica se o usuário está vinculado ao Google
                                      if (user.providerData.any((info) =>
                                          info.providerId == "google.com")) {
                                        // Checa se o Google é o único provedor vinculado
                                        bool hasOnlyGoogle = user.providerData
                                            .every((info) =>
                                                info.providerId ==
                                                    "google.com" ||
                                                info.providerId == "firebase");

                                        if (hasOnlyGoogle) {
                                          // Se Google for o único provedor, alerta avisando que é único provedor
                                          await areYouSureOnlyGoogle(context);
                                        } else {
                                          // Caso contrário, desvincula o Google
                                          await user.unlink("google.com");

                                          // Força a atualização do estado da tela
                                          setState(
                                              () {}); // Atualiza a UI para refletir a desconexão

                                          // Recarrega o usuário
                                          await FirebaseAuth
                                              .instance.currentUser
                                              ?.reload();

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Conta do Google desvinculada com sucesso.'),
                                            ),
                                          );
                                        }
                                      } else {
                                        // Caso o usuário não esteja vinculado ao provedor do Google
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Usuário não está vinculado ao Google.'),
                                          ),
                                        );
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'requires-recent-login') {
                                        // Solicita ao usuário que faça login novamente
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Reautenticação necessária. Por favor, faça login novamente.'),
                                          ),
                                        );
                                      } else {
                                        log('Erro ao desvincular conta do Google: ${e.message}');
                                      }
                                    } catch (e) {
                                      log('Erro desconhecido ao desvincular conta do Google: $e');
                                    }
                                  }
                                },
                                child: const Text(
                                  'Desvincular',
                                  style: TextStyle(
                                    color: Color(0XFF4300B1),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(),
              providers.isEmpty ||
                      (providers.length == 1 && providers.contains("password"))
                  ? MyRow(
                      widget: Image.asset(
                        'lib/assets/images/IconNetwork.png',
                        width: 26, // Ajuste conforme necessário
                        height: 26,
                      ),
                      subtitle: 'Nenhuma conta vinculada',
                      onTap: () => (),
                      textButton: '')
                  : Container(),
              const SizedBox(height: 30),
              const Text(
                'Conta',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              MyRow(
                  widget: Image.asset(
                    'lib/assets/images/IconAccountDelete.png',
                    width: 26, // Ajuste conforme necessário
                    height: 26,
                  ),
                  subtitle: 'Desativar sua conta',
                  textButton: 'Desativar',
                  onTap: () async {
                    final user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      // Mostra um diálogo de confirmação antes de excluir a conta

                      await Future.delayed(Duration.zero);
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController passwordController =
                              TextEditingController();

                          return AlertDialog(
                            title: const Text('Tem certeza?'),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                    'Tem certeza de que deseja excluir sua conta?'),
                                const Text(
                                    'Confirme sua senha para prosseguir'),
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration:
                                      const InputDecoration(labelText: 'Senha'),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();

                                  try {
                                    // Reautentica o usuário antes de excluir a conta
                                    AuthCredential credential =
                                        EmailAuthProvider.credential(
                                      email: user.email!,
                                      password: passwordController.text,
                                    );
                                    await user.reauthenticateWithCredential(
                                        credential);

                                    // Exclua a conta do usuário após a reautenticação
                                    await user.delete();

                                    // Redirecione o usuário para a tela de login ou execute outras ações necessárias
                                    await ref
                                        .read(userFirestoreRepositoryProvider)
                                        .deleteUserDocument(user);
                                    ref.read(logoutProvider.future);
                                    log('Conta excluída com sucesso.');
                                  } on FirebaseAuthException catch (e) {
                                    log('Erro ao excluir a conta: ${e.code}, ${e.message}');
                                  } catch (e) {
                                    log('Erro desconhecido ao excluir a conta: $e');
                                  }
                                },
                                child: const Text('Deletar conta'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      log('Usuário não autenticado');
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget MyRow({
    required String subtitle,
    required String textButton,
    Widget? widget,
    required final VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Row(
          children: [
            if (widget != null)
              Row(
                children: [
                  widget,
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            Text(subtitle),
            const Spacer(),
            InkWell(
              onTap: onTap,
              child: Text(
                textButton,
                style: const TextStyle(
                  color: Color(0XFF4300B1),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
