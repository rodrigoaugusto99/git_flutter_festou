import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/login%20e%20seguran%C3%A7a/esqueci_senha.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/login%20e%20seguran%C3%A7a/widget/patternedButton.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/login%20e%20seguran%C3%A7a/widget/passwordField.dart';
import 'package:git_flutter_festou/src/services/auth_services.dart';
import 'package:git_flutter_festou/src/services/user_service.dart';

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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      yourFunctionToBeCalled();
      displayAuthProviderList();
      showUserProvider();
      setState(() {});
    });
  }

  void yourFunctionToBeCalled() {
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

  Widget buildGoogleWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'lib/assets/images/google.png',
              width: 24,
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

  Future<bool> reauthentication(User user, String senhaAtual) async {
    try {
      if (providers.contains("google.com") && senhaAtual == '') {
        await AuthService(context: context).signInWithGoogle();
        return true; // Retorna true se a reautenticação foi bem-sucedida
      } else {
        // Reautentica o usuário com a nova senha
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: senhaAtual,
        );
        await user.reauthenticateWithCredential(credential);
        return true; // Retorna true se a reautenticação foi bem-sucedida
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Ops...'),
                content: const Text('Senha atual inválida!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Fechar'),
                  ),
                ],
              );
            });
        return false; // Retorna false se a senha for inválida
      } else {
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Ops...'),
                content: const Text(
                    'Não foi possível reautenticar. Refaça o login.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Fechar'),
                  ),
                ],
              );
            });
        log('Erro ao reautenticar: $e');
        return false; // Retorna false para qualquer outro erro
      }
    }
  }

  Future<void> areYouSureAboutDisconnect(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final providersData = user?.providerData;
    bool onlyGoogle = false;

    if (user == null) {
      log('Usuário não autenticado');
      return;
    }

    if (providersData!.length == 1 &&
        providersData[0].providerId == "google.com") {
      onlyGoogle = true;
    }

    if (providers.contains("google.com")) {
      // Exibe o diálogo de confirmação
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmação de Desvinculação'),
            content: onlyGoogle
                ? const Text(
                    'O Google é seu único provedor. Se você desvincular, precisará configurar uma senha para continuar acessando sua conta.')
                : const Text(
                    'Tem certeza de que deseja desvincular o Google? O login só poderá ser realizado via e-mail e senha.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  //

                  await reauthentication(user, '');

                  // Abre o pop-up para cadastrar nova senha
                  if (onlyGoogle) {
                    final BuildContext contextPassword =
                        Navigator.of(context).context;
                    Navigator.of(context)
                        .pop(); // Fecha o diálogo de confirmação
                    await showDialog(
                      context: contextPassword,
                      builder: (BuildContext contextPassword) {
                        final newPasswordController = TextEditingController();
                        final confirmPasswordController =
                            TextEditingController();

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
                              PasswordField(
                                controller: newPasswordController,
                                label: 'Nova senha',
                              ),
                              const SizedBox(height: 16),
                              PasswordField(
                                controller: confirmPasswordController,
                                label: 'Confirmar senha',
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(contextPassword).pop(),
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
                                  final BuildContext contextEmpty =
                                      Navigator.of(contextPassword).context;
                                  await showDialog(
                                      context: contextEmpty,
                                      builder: (BuildContext contextEmpty) {
                                        return AlertDialog(
                                            title: const Text('Ops...'),
                                            content: const Text(
                                                'Os campos não podem estar vazios.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(contextEmpty)
                                                        .pop(),
                                                child: const Text('Fechar'),
                                              ),
                                            ]);
                                      });
                                  return;
                                }

                                if (newPassword.length < 6) {
                                  final BuildContext contextLessThanSix =
                                      Navigator.of(contextPassword).context;
                                  await showDialog(
                                      context: contextLessThanSix,
                                      builder:
                                          (BuildContext contextLessThanSix) {
                                        return AlertDialog(
                                            title: const Text('Ops...'),
                                            content: const Text(
                                                'A senha deve conter no mínimo 6 caracteres.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(
                                                        contextLessThanSix)
                                                    .pop(),
                                                child: const Text('Fechar'),
                                              ),
                                            ]);
                                      });
                                  return;
                                }

                                if (newPassword != confirmPassword) {
                                  final BuildContext contextWrongPassword =
                                      Navigator.of(contextPassword).context;
                                  await showDialog(
                                      context: contextWrongPassword,
                                      builder:
                                          (BuildContext contextWrongPassword) {
                                        return AlertDialog(
                                            title: const Text('Ops...'),
                                            content: const Text(
                                                'As senhas não coincidem.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(
                                                        contextWrongPassword)
                                                    .pop(),
                                                child: const Text('Fechar'),
                                              ),
                                            ]);
                                      });
                                  return;
                                }

                                try {
                                  // Atualiza a senha do usuário
                                  await user.updatePassword(newPassword);
                                  await user.unlink("google.com");

                                  setState(() {
                                    displayAuthProviderList();
                                  });

                                  Navigator.of(contextPassword).pop();

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
                  } else {
                    Navigator.of(context)
                        .pop(); // Fecha o diálogo de confirmação
                    await user.unlink("google.com");

                    setState(() {
                      displayAuthProviderList();
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Conta do Google desvinculada com sucesso!'),
                      ),
                    );
                  }
                },
                child: const Text('Confirmar'),
              ),
            ],
          );
        },
      );
    } else {
      log('O usuário não possui o provedor Google associado.');
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
          'Login e segurança',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              PatternedButton(
                widget: Image.asset(
                  'lib/assets/images/IconPassword.png',
                  width: 26,
                  height: 26,
                ),
                title: 'Senha',
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
                              String senhaAtual = '';
                              bool itsRegister = true;

                              if (providers.contains("password")) {
                                senhaAtual = senhaAtualController.text;
                                itsRegister = false;
                              }

                              if (novaSenha.isEmpty || confirmarSenha.isEmpty) {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Ops...'),
                                      content: const Text(
                                          'As senhas não podem estar vazias.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('Fechar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return;
                              }

                              if (novaSenha != confirmarSenha) {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Ops...'),
                                      content: const Text(
                                          'As senhas não coincidem.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('Fechar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return;
                              }

                              if (senhaAtual.isNotEmpty || itsRegister) {
                                // Verifica se a reautenticação foi bem-sucedida
                                bool reauthenticated =
                                    await reauthentication(user, senhaAtual);
                                if (!reauthenticated) {
                                  return; // Se falhou na reautenticação, retorna sem continuar
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
                              } else {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Ops...'),
                                      content: const Text(
                                          'É necessário informar a senha atual.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('Fechar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return;
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Ops...'),
                                      content: const Text(
                                          'A senha fornecida é muito fraca.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('Fechar'),
                                        ),
                                      ],
                                    );
                                  },
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
                  ? PatternedButton(
                      widget: Image.asset(
                        'lib/assets/images/google.png',
                        width: 26,
                        height: 26,
                      ),
                      title: 'Google',
                      textButton: 'Desvincular',
                      onTap: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          try {
                            await areYouSureAboutDisconnect(context);

                            // Recarrega o usuário
                            await FirebaseAuth.instance.currentUser?.reload();
                          } on FirebaseAuthException catch (e) {
                            log('Erro ao desvincular conta do Google: ${e.message}');
                          } catch (e) {
                            log('Erro desconhecido ao desvincular conta do Google: $e');
                          }
                        }
                      },
                    )
                  : Container(),
              providers.isEmpty ||
                      (providers.length == 1 && providers.contains("password"))
                  ? PatternedButton(
                      widget: Image.asset(
                        'lib/assets/images/IconNetwork.png',
                        width: 26,
                        height: 26,
                      ),
                      title: 'Nenhuma conta vinculada',
                      onTap: () => (),
                      textButton: '')
                  : Container(),
              const SizedBox(height: 30),
              const Text(
                'Conta',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              PatternedButton(
                  widget: Image.asset(
                    'lib/assets/images/IconAccountDelete.png',
                    width: 26,
                    height: 26,
                  ),
                  title: 'Excluir minha conta',
                  textButton: 'Excluir',
                  onTap: () async {
                    final user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      await Future.delayed(Duration.zero);
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          final BuildContext context2 =
                              Navigator.of(context).context;
                          final BuildContext context3 =
                              Navigator.of(context).context;
                          final BuildContext context4 =
                              Navigator.of(context).context;
                          TextEditingController passwordController =
                              TextEditingController();

                          return AlertDialog(
                            title: const Text('Exclusão de Conta'),
                            content: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    'Sua conta será excluída e todos os seus dados serão perdidos, sem possibilidade de recuperação. Deseja continuar?'),
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

                                  if (!providers.contains("password")) {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Ops...'),
                                          content: const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  'É necessário possuir uma senha cadastrada para prosseguir com exclusão de conta.'),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return;
                                  }

                                  //Primeiro validar se não há contrato ativo ou espaço cadastrado
                                  final userModel =
                                      await UserService().getCurrentUserModel();

                                  final queryReservationsSnapshot =
                                      await FirebaseFirestore.instance
                                          .collection('reservations')
                                          .where('client_id',
                                              isEqualTo: userModel!.uid)
                                          .where('selectedFinalDate',
                                              isGreaterThan: DateTime.now())
                                          .limit(1)
                                          .get(); // Limita para apenas verificar se existe um contrato ativo
                                  if (queryReservationsSnapshot
                                      .docs.isNotEmpty) {
                                    await showDialog(
                                      context: context2,
                                      builder: (BuildContext context2) {
                                        return AlertDialog(
                                          title: const Text('Ops...'),
                                          content: const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  'O usuário possui reservas não consumadas.'),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context2).pop();
                                              },
                                              child: const Text('Ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return;
                                  }

                                  final querySpacesSnapshot =
                                      await FirebaseFirestore.instance
                                          .collection('spaces')
                                          .where('user_id',
                                              isEqualTo: userModel.uid)
                                          .limit(1)
                                          .get(); // Limita para apenas verificar se existe um espacço cadastrado

                                  if (querySpacesSnapshot.docs.isNotEmpty) {
                                    await showDialog(
                                      context: context2,
                                      builder: (BuildContext context2) {
                                        return AlertDialog(
                                          title: const Text('Ops...'),
                                          content: const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  'O usuário possui espaço cadastrado.'),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context2).pop();
                                              },
                                              child: const Text('Ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return;
                                  }

                                  await showDialog(
                                      context: context3,
                                      builder: (BuildContext context3) {
                                        return AlertDialog(
                                          title:
                                              const Text('Exclusão de Conta'),
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                  'Confirme sua senha para prosseguir'),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16.0),
                                                child: PasswordField(
                                                  controller:
                                                      passwordController,
                                                  label: 'Senha',
                                                  padding: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context3).pop();
                                              },
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context3).pop();

                                                try {
                                                  // Reautentica o usuário antes de excluir a conta
                                                  AuthCredential credential =
                                                      EmailAuthProvider
                                                          .credential(
                                                    email: userModel.email,
                                                    password:
                                                        passwordController.text,
                                                  );
                                                  await user
                                                      .reauthenticateWithCredential(
                                                          credential);

                                                  // Exclua a conta do usuário após a reautenticação
                                                  await user.delete();

                                                  // Redirecione o usuário para a tela de login ou execute outras ações necessárias
                                                  await ref
                                                      .read(
                                                          userFirestoreRepositoryProvider)
                                                      .deleteUserDocument(user);
                                                  ref.read(
                                                      logoutProvider.future);
                                                  log('Conta excluída com sucesso.');
                                                } on FirebaseAuthException catch (e) {
                                                  if (e.code ==
                                                      'invalid-credential') {
                                                    await showDialog(
                                                        context: context4,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Ops...'),
                                                            content: const Text(
                                                                'Senha atual inválida!'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                            context4)
                                                                        .pop(),
                                                                child: const Text(
                                                                    'Fechar'),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  }
                                                  log('Erro ao excluir a conta: ${e.code}, ${e.message}');
                                                } catch (e) {
                                                  log('Erro desconhecido ao excluir a conta: $e');
                                                }
                                              },
                                              child: const Text('Confirmar'),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: const Text('Confirmar'),
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
}
