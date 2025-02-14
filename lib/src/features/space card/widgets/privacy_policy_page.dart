import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festou/src/core/providers/application_providers.dart';
import 'package:festou/src/core/ui/helpers/messages.dart';
import 'package:festou/src/features/login/login_page.dart';

class PrivacyPolicyPage extends ConsumerStatefulWidget {
  final bool duringLogin;

  const PrivacyPolicyPage({super.key, this.duringLogin = false});

  @override
  ConsumerState<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends ConsumerState<PrivacyPolicyPage> {
  final String privacyPolicyHtml = '''
  <h1>Política de Privacidade do Festou</h1>
  <p>A presente Política de Privacidade contém informações sobre a coleta, uso, armazenamento, tratamento e proteção dos dados pessoais dos usuários e/ou visitantes do Festou, com a finalidade de demonstrar absoluta transparência quanto ao assunto e esclarecer a todos os interessados sobre os tipos de dados que são coletados, os motivos da coleta e a forma como os usuários podem gerenciar ou excluir suas informações pessoais.</p>
  <p>O Festou foi desenvolvido e seus serviços são fornecidos pela Festou Corporation – CNPJ 12.345.678/0009-01, sendo assim, portanto, sua proprietária e detentora de todos os seus direitos.</p>
  <p>O presente documento foi elaborado em conformidade com a Lei Geral de Proteção de Dados Pessoais (Lei nº 13.709/18), o Marco Civil da Internet (Lei nº 12.965/14) e o Regulamento da UE nº 2016/6790. Este documento poderá ser atualizado em decorrência de eventual atualização normativa, razão pela qual se convida o usuário a consultar periodicamente esta seção.</p>
  <p>Ao utilizar os serviços fornecidos pelo Festou, de forma expressa e formal, o usuário concordará com a coleta e uso de suas informações pessoais nos limites e formas estabelecidas nesta Política de Privacidade.</p>
  <p>Toda e qualquer informação pessoal coletada pelo Festou será utilizada somente para o serviço em si e com o intuito de proporcionar melhorias ao Sistema. As informações coletadas não serão utilizadas ou mesmo compartilhadas com terceiros, excetuando-se as condições aqui previstas.</p>
  <p>Os termos usados ​​nesta Política de Privacidade têm os mesmos significados que os nossos Termos e Condições, que estão acessíveis nos aplicativos, a menos que definido de outra forma nesta Política de Privacidade.</p>
  <h2>Coleta e Utilização de Informações</h2>
  <p>Ao utilizar o Festou, será exigido que o usuário forneça informações de identificação pessoal, tais como, mas não se limitando a, nome completo, endereço eletrônico (e-mail), cidade de residência, CPF/CNPJ, telefone e endereço completo. Todos estes dados (informações pessoais) solicitados serão retidos na base do Festou e receberão o devido tratamento, conforme esta Política de Privacidade.</p>
  <p>O Festou poderá utilizar serviços de terceiros, que por sua vez podem realizar coletas de dados (informações pessoais) conforme suas políticas de privacidade.</p>
  <h2>Dados de Log</h2>
  <p>Caso ocorra algum erro ou instabilidade na utilização do Festou, serão coletados dados e informações (através de produtos de terceiros) em seu dispositivo móvel (telefone celular) chamados de Log Data. Esses dados de registro podem incluir informações como o endereço do protocolo de Internet ("IP") do seu dispositivo móvel, nome do dispositivo, versão do sistema operacional, configuração do aplicativo, hora e data de uso e outras estatísticas.</p>
  <h2>Cookies</h2>
  <p>O Festou não utiliza de forma direta cookies, entretanto, poderão eventualmente ser utilizados por terceiros ou mesmo bibliotecas com o objetivo de coletar informações que permitam a melhora de seus serviços. O usuário do Festou sempre terá a opção de aceitar ou recusar esses cookies, bem como ser informado sobre o momento em que um cookie será enviado ao seu dispositivo. Importante informar que, caso decida pela recusa dos cookies, poderá haver a possibilidade de não usufruir da totalidade dos serviços do Festou. Cookies são arquivos com uma pequena quantidade de dados que são comumente usados ​​como identificadores exclusivos anônimos. Eles são enviados para o seu navegador a partir dos sites que você visita e são armazenados na memória interna do seu dispositivo.</p>
  <h2>Provedores de Serviço</h2>
  <p>O Festou, para seu perfeito funcionamento e constante aprimoramento, poderá contar com serviços prestados por terceiros (pessoas físicas e/ou jurídicas). Estes terceiros (pessoas físicas e/ou jurídicas) terão acesso às informações pessoais dos usuários do Festou, condição necessária para que possam executar suas atribuições contratadas. Todos estes terceiros (pessoas físicas e/ou jurídicas) envolvidos no Festou são formalmente contratados e proibidos de divulgar ou mesmo utilizar as informações dos usuários para outro fim, que não o estritamente constante no escopo de seus contratos.</p>
  <h2>Segurança</h2>
  <p>[Nome da Empresa] valoriza a confiança concedida por cada usuário do Festou e garante que nunca deixará de medir esforços para proteger desde o dado mais sensível até aquele menos relevante, empregando todos os meios lícitos e disponíveis em tal proteção. Entretanto, sabemos que não existe nenhum método de transmissão pela internet, ou método de armazenamento eletrônico 100% seguro e confiável, razão pela qual, situações excepcionais poderão ocorrer, mas mesmo nessas atuaremos da melhor e mais eficiente forma possível.</p>
  <h2>Links para Outros Sites</h2>
  <p>O Festou poderá conter links de direcionamento para outros sites, de propriedade de terceiros. Recomendamos que o usuário revise as Políticas de Privacidade destes sites de terceiros. [Nome da Empresa] não possui controle ou gestão sobre estes sites de terceiros, portanto, não poderá ser responsabilizada por eventual utilização inadequada dos dados pessoais dos usuários por parte destes terceiros.</p>
  <h2>Privacidade Infantil</h2>
  <p>O Festou, por sua própria natureza, é direcionado a usuários que tenham 16 (dezesseis) anos ou mais. Não haverá coleta intencional de dados pessoais de usuários que tenham menos de 16 (dezesseis) anos. Caso seja descoberto que o usuário cadastrado não preenche este requisito, haverá sua imediata exclusão e eliminação completa de todos os seus dados fornecidos em nossa base. Se o responsável legal de algum usuário com menos de 16 (dezesseis) anos tiver conhecimento de que seus dados estão em nossas bases, poderá nos contactar imediatamente para que as necessárias medidas sejam adotadas.</p>
  <h2>Alterações nesta Política de Privacidade</h2>
  <p>Esta Política de Privacidade poderá ser atualizada a qualquer tempo. Cada usuário do Festou será notificado quando ocorrerem alterações nesta Política de Privacidade.</p>
  <h2>Contate-nos</h2>
  <p>Se você tiver alguma dúvida ou sugestão sobre nossa Política de Privacidade, não hesite em nos contatar em fale-conosco@festou.com.br.</p>
  <p>Esta Política de Privacidade é efetiva desde 20/06/2024.</p>
  ''';

  bool _isAccepted = false;

  @override
  void initState() {
    super.initState();
    _fetchPrivacyPolicyAcceptance();
  }

  void _fetchPrivacyPolicyAcceptance() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final userQuery =
          await usersCollection.where('uid', isEqualTo: currentUser.uid).get();
      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;
        final userData = userDoc.data();
        if (userData.containsKey('privacy_policy_acceptance')) {
          setState(() {
            _isAccepted = userData['privacy_policy_acceptance'] ?? false;
          });
        }
      }
    }
  }

  void _updatePrivacyPolicyAcceptance(BuildContext context) async {
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
                {'privacy_policy_acceptance': true}, SetOptions(merge: true));
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
                    'Desmarcar essa opção resultará no seu logout. Deseja continuar?'),
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
                {'privacy_policy_acceptance': false}, SetOptions(merge: true));
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
          'Política de privacidade',
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
              data: privacyPolicyHtml,
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
                    const Text("Li e aceito a política de privacidade"),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                _updatePrivacyPolicyAcceptance(context);
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
                  Navigator.of(context).pushReplacementNamed('/login');
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
