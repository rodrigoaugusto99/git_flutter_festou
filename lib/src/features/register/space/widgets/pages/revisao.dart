import 'package:flutter/material.dart';

class Revisao extends StatefulWidget {
  const Revisao({super.key});

  @override
  State<Revisao> createState() => _RevisaoState();
}

class _RevisaoState extends State<Revisao> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      'Salvar e sair',
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      'Dúvidas?',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                const Text(
                  'Revise seu anuncio',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Text(
                    'Confira o que mostraremos aos hospedes.\nCertifique-se de que está tudo certo'),
                Container(
                  color: Colors.grey,
                  height: 300,
                  width: 300,
                ),
                const Text(
                  'Proximo passo?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Confirme as informacoes e publique o anuncio',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Entraremos em contato se voce precisar verificar sua idenmtidade ou se registrar junto ao governo local',
                ),
                const Text(
                  'Configure o calendario',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Escolha as datas em que sua acomodacao está disponivel. O anuncio fcará visaivel por 24 hortas depois da publicacao',
                ),
                const Text(
                  'Ajuste as configuraçao',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Defina as regras de segurança da casa, selecione uma politica de cancelmaento, esoclha como os hospedes podem reservar e muito mais',
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Voltar',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Revisao(),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: const Text(
                      'Avançar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
