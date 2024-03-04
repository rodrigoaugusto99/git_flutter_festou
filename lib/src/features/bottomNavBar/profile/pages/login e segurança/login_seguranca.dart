import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/login%20e%20seguran%C3%A7a/esqueci_senha.dart';

class LoginSeguranca extends ConsumerStatefulWidget {
  const LoginSeguranca({super.key});

  @override
  ConsumerState<LoginSeguranca> createState() => _LoginSegurancaState();
}

class _LoginSegurancaState extends ConsumerState<LoginSeguranca>
    with WidgetsBindingObserver {
  @override
  void initState() {
    // Adiciona o observer para monitorar mudanças de ciclo de vida do widget
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
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
            const Text("Google"),
            Image.asset(
              'lib/assets/images/google.png',
              width: 24, // Ajuste conforme necessário
              height: 24,
            ),
          ],
        ),
        InkWell(
          onTap: () {},
          child: const Text(
            'Desconectar',
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFacebookWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text("Facebook"),
            Image.asset(
              'lib/assets/images/Facebook_icon.svg.png.png',
              width: 24, // Ajuste conforme necessário
              height: 24,
            ),
          ],
        ),
        InkWell(
          onTap: () {},
          child: const Text(
            'Desconectar',
            style: TextStyle(
              decoration: TextDecoration.underline,
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

  Future areYouSureOnlyGoogle() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Tem certeza?'),
            content: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'O google é seu único provedor, se você desvincular, para usar essa conta, terá que criar uma senha com esse email.\n'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o diálogo
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Fecha o diálogo

                  try {
                    // Exclua a conta do usuário
                    await user.unlink("google.com");

                    //todo:
                    /* logica para deletar o usuario que tem apenas o goole como provedor,
                    pois: 1) se desvincular, ficará apenas o usuario lá no auth com provedor vazio, 
                    eu queria excluir tudo ali; 2) pra deletar de fato, precisa de reautenticacao sem senha,
                    pois só há google, nao há email/senha, entao precisaria de reautenticar com link.
                    seria com link mesmo? há um problema em deixar o provedor la vazio?*/
                    //?

                    //?
                    // Redirecione o usuário para a tela de login ou execute outras ações necessárias
                    /*await ref
                        .read(userFirestoreRepositoryProvider)
                        .deleteUserDocument(user);*/
                    //ref.read(logoutProvider.future);
                    //log('Conta excluída com sucesso.');
                    // Indica que o usuário confirmou a exclusão

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Conta do Google desvinculada com sucesso!'),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    log('Erro ao excluir a conta: ${e.code}, ${e.message}');
                    // Trate os erros conforme necessário, exiba mensagens ao usuário, etc.
                  } catch (e) {
                    log('Erro desconhecido ao excluir a conta: $e');
                    // Trate outros erros conforme necessário.
                  }
                },
                child: const Text('Deletar conta'),
              ),
            ],
          );
        },
      );
    } else {
      log('Usuario não autenticado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Login e Segurança',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                'Login',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              MyRow(
                title: 'Senha',
                subtitle: 'Ultima atualização há \$x dias',
                textButton: !isUpdatingPassword ? 'Atualizar' : 'Cancelar',
                onTap: () {
                  setState(() {
                    isUpdatingPassword = !isUpdatingPassword;
                  });
                },
              ),
              if (isUpdatingPassword) ...[
                // Container com os campos de atualização da senha
                Column(
                  children: [
                    const TextField(
                      decoration: InputDecoration(labelText: 'Senha Atual'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const EsqueciSenha(),
                                  ),
                                ),
                            child: const Text('Esqueci minha senha')),
                      ],
                    ),
                    const SizedBox(height: 0),
                    const TextField(
                      decoration: InputDecoration(labelText: 'Nova Senha'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 0),
                    const TextField(
                      decoration: InputDecoration(labelText: 'Confirmar Senha'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 0),
                    ElevatedButton(
                      onPressed: () {
                        // Implemente a lógica para "Alterar Senha"
                      },
                      child: const Text('Alterar Senha'),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 30),
              const Text(
                'Contas sociais',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              providers.contains("google.com")
                  ? Column(
                      children: [
                        buildGoogleWidget(),
                        ElevatedButton(
                          onPressed: () async {
                            final user = FirebaseAuth.instance.currentUser;

                            if (user != null) {
                              try {
                                // Verifica se o usuário está vinculado ao provedor do Google
                                if (user.providerData.any((info) =>
                                    info.providerId == "google.com")) {
                                  if (user.providerData.any((info) =>
                                      info.providerId != "password")) {
                                    //se desvincular, deve deletar o usuario, pois só há google como provedor.

                                    await areYouSureOnlyGoogle();
                                  } else {
                                    // Desvincula a conta do Google
                                    await user.unlink("google.com");
                                  }
                                } else {
                                  // Caso o usuário não esteja vinculado ao provedor do Google
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Usuário não está vinculado ao Google.'),
                                    ),
                                  );
                                }
                              } on FirebaseAuthException catch (e) {
                                // Trata exceções específicas, se necessário
                                log('Erro ao desvincular conta do Google, usuario nao autenticado: ${e.message}');
                              }
                            }
                          },
                          child: const Text('Desvincular Conta do Google'),
                        )
                      ],
                    )
                  : Container(),
              providers.contains("facebook.com")
                  ? buildFacebookWidget()
                  : Container(),
              providers.isEmpty ||
                      (providers.length == 1 && providers.contains("password"))
                  ? const Text('Nenhuma conta vinculada')
                  : Container(),
              const SizedBox(height: 30),
              const Text(
                'Conta',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              MyRow(
                  title: 'Desativar sua conta',
                  subtitle: '',
                  textButton: 'Desativar',
                  onTap: () async {
                    final user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      // Mostra um diálogo de confirmação antes de excluir a conta
                      Navigator.of(context).pop();
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
                                    // Trate os erros conforme necessário, exiba mensagens ao usuário, etc.
                                  } catch (e) {
                                    log('Erro desconhecido ao excluir a conta: $e');
                                    // Trate outros erros conforme necessário.
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
                      // Se o usuário não estiver autenticado, trate conforme necessário.
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget MyRow({
    required String title,
    required String subtitle,
    required String textButton,
    required final VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Text(subtitle),
            ],
          ),
          InkWell(
            onTap: onTap,
            child: Text(
              textButton,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
