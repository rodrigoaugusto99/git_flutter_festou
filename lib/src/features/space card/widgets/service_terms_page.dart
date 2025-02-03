import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/login/login_page.dart';

class ServiceTermsPage extends ConsumerStatefulWidget {
  final bool duringLogin;

  const ServiceTermsPage({super.key, this.duringLogin = false});

  @override
  ConsumerState<ServiceTermsPage> createState() => _ServiceTermsPageState();
}

class _ServiceTermsPageState extends ConsumerState<ServiceTermsPage> {
  final String serviceTermsHtml = '''
  <h1>Termos de Serviço do Festou</h1>
  <h2>1. Introdução</h2>
  <p>Bem-vindo ao Festou. Estes Termos de Serviço regem o uso de nosso aplicativo móvel para aluguel de espaços para eventos. Ao utilizar nosso aplicativo, você concorda com estes termos. Se você não concorda com qualquer parte destes termos, não deve usar o Festou.</p>
  <h2>2. Definições</h2>
  <p><strong>Usuário:</strong> Qualquer pessoa que se cadastra no Festou, podendo ser um Locatário ou Locador.<br>
  <strong>Locatário:</strong> Usuário que aluga espaços para realizar eventos.<br>
  <strong>Locador:</strong> Usuário que disponibiliza espaços para aluguel.<br>
  <strong>Serviço:</strong> Mediação de contratos de aluguel de espaços para eventos através do aplicativo Festou.</p>
  <h2>3. Cadastro</h2>
  <p>Para utilizar o Festou, o usuário deve fornecer as seguintes informações:<br>
  Nome completo<br>
  CPF ou CNPJ<br>
  Telefone<br>
  E-mail<br>
  Endereço completo<br>
  Senha<br>
  Ao se cadastrar, o usuário automaticamente assume o papel de Locatário.</p>
  <h2>4. Migração de Locatário para Locador</h2>
  <p>O usuário pode solicitar a migração para Locador. Poderá ser solicitado ao Locador fornecer informações adicionais e documentos que comprovem a propriedade ou direito de uso do espaço. A migração está sujeita à aprovação da equipe do Festou.</p>
  <h2>5. Uso do Serviço</h2>
  <p>O Festou atua apenas como intermediário, facilitando a comunicação e os contratos de aluguel entre Locatários e Locadores. O Festou não possui, gerencia ou aluga diretamente os espaços disponíveis.</p>
  <h2>6. Obrigações dos Usuários</h2>
  <p><strong>Locatários:</strong> Devem cumprir todas as regras do espaço alugado e realizar o pagamento conforme acordado.<br>
  <strong>Locadores:</strong> Devem garantir que os espaços estejam em condições adequadas para o uso e cumprir com as obrigações contratuais.</p>
  <h2>7. Pagamentos</h2>
  <p>Todos os pagamentos são realizados através do aplicativo Festou. O Festou cobra uma taxa de serviço sobre o valor do aluguel, que será detalhada no momento da contratação.</p>
  <h2>8. Cancelamentos e Reembolsos</h2>
  <p>Políticas de cancelamento e reembolso variam de acordo com o Locador e devem ser claramente especificadas no contrato de aluguel. Em caso de cancelamento, o Festou retém a taxa de serviço.</p>
  <h2>9. Responsabilidades</h2>
  <p>O Festou não se responsabiliza por danos, perdas ou problemas decorrentes do uso dos espaços alugados. O usuário é responsável por fornecer informações verídicas e atualizadas no aplicativo.</p>
  <h2>10. Privacidade</h2>
  <p>Coletamos e utilizamos informações pessoais conforme nossa Política de Privacidade, disponível no aplicativo. As informações dos usuários são protegidas e não são compartilhadas com terceiros sem consentimento.</p>
  <h2>11. Modificações nos Termos</h2>
  <p>O Festou pode alterar estes Termos de Serviço a qualquer momento. As alterações serão notificadas aos usuários, que devem aceitar os novos termos para continuar utilizando o serviço.</p>
  <h2>12. Resolução de Disputas</h2>
  <p>Em caso de disputas entre usuários, o Festou pode mediar a situação, mas não é obrigado a resolver o conflito. Disputas legais serão resolvidas conforme as leis vigentes no país de operação do usuário.</p>
  <h2>13. Disposições Gerais</h2>
  <p>Estes Termos de Serviço constituem o acordo completo entre o usuário e o Festou. Caso alguma disposição destes termos seja considerada inválida, as demais disposições continuarão em pleno vigor e efeito.</p>
  <h2>14. Contato</h2>
  <p>Para dúvidas ou suporte, entre em contato através do suporte@festou.com.<br>
  Última atualização: 20/06/2024</p>
  ''';

  bool _isAccepted = false;

  @override
  void initState() {
    super.initState();
    _fetchServiceTermsAcceptance();
  }

  void _fetchServiceTermsAcceptance() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final userQuery =
          await usersCollection.where('uid', isEqualTo: currentUser.uid).get();
      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;
        final userData = userDoc.data();
        if (userData.containsKey('service_terms_acceptance')) {
          setState(() {
            _isAccepted = userData['service_terms_acceptance'] ?? false;
          });
        }
      }
    }
  }

  void _updateServiceTermsAcceptance(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final userQuery =
          await usersCollection.where('uid', isEqualTo: currentUser.uid).get();
      if (userQuery.docs.isNotEmpty) {
        final userDocRef = usersCollection.doc(userQuery.docs.first.id);

        if (_isAccepted) {
          try {
            await userDocRef.set(
                {'service_terms_acceptance': true}, SetOptions(merge: true));
            Messages.showSuccess('Aceite atualizado com sucesso', context);
            if (!widget.duringLogin) {
              Navigator.of(context).pop(false);
            } else {
              Navigator.of(context).pushReplacementNamed('/auth');
            }
          } catch (e) {
            Messages.showError('Erro ao salvar, tente novamente: $e', context);
          }
        } else {
          bool? confirmLogout = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Sair do Festou'),
                content: const Text(
                    'Não aceitar os Termos de Serviço resultará no seu logout. Deseja continuar?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: const Text('Confirmar'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      ref.invalidate(userFirestoreRepositoryProvider);
                      ref.invalidate(userAuthRepositoryProvider);
                      ref.read(logoutProvider.future);
                    },
                  ),
                ],
              );
            },
          );

          if (confirmLogout == true) {
            await userDocRef.set(
                {'service_terms_acceptance': false}, SetOptions(merge: true));
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (Route<dynamic> route) => false,
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double paddingBottom = widget.duringLogin ? 10 : 20;
    return Scaffold(
      appBar: AppBar(
        leading: !widget.duringLogin
            ? Padding(
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
              )
            : Container(),
        centerTitle: true,
        title: const Text(
          'Termos de serviços',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Html(
              data: serviceTermsHtml,
              style: {
                "h1": Style(
                  fontSize: FontSize.xLarge,
                  fontWeight: FontWeight.bold,
                ),
                "h2": Style(
                  fontSize: FontSize.large,
                  fontWeight: FontWeight.bold,
                ),
                "p": Style(
                  fontSize: FontSize.medium,
                ),
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _isAccepted,
                      onChanged: (bool? value) {
                        setState(() {
                          _isAccepted = value ?? false;
                        });
                      },
                    ),
                    const Text("Li e aceito os termos de serviço"),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                _updateServiceTermsAcceptance(context);
              },
              child: Padding(
                padding: EdgeInsets.only(
                    top: 20, bottom: paddingBottom, left: 30, right: 30),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
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
                  child: const Text(
                    'Salvar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            if (widget.duringLogin)
              GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  ref.invalidate(userFirestoreRepositoryProvider);
                  ref.invalidate(userAuthRepositoryProvider);
                  ref.read(logoutProvider.future);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 30, right: 30),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
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
                    child: const Text(
                      'Cancelar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
    );
  }
}
