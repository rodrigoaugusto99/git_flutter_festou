import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/tipo_espaco.dart';
import 'package:git_flutter_festou/src/helpers/helpers.dart';
import 'package:git_flutter_festou/src/helpers/keys.dart';

class NewSpaceRegister extends StatefulWidget {
  const NewSpaceRegister({super.key});

  @override
  State<NewSpaceRegister> createState() => _NewSpaceRegisterState();
}

class _NewSpaceRegisterState extends State<NewSpaceRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Cadastrar',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left: 38),
                child: Text(
                  'É muito facil anunciar no Festou!',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff4300B1)),
                ),
              ),
              SizedBox(height: 35),
              NewWidget(
                iconData: Icons.messenger_sharp,
                text1: '1.',
                text2: '\nDescreva sua\nacomodação',
                text3:
                    'Compartilhe algumas informacoes basicas, como a localizaçao e quantos hospedes podem ficar no local',
              ),
              SizedBox(height: 28),
              NewWidget(
                  iconData: Icons.star,
                  text1: '2.',
                  text2: '\nFaça com que se\ndestaque',
                  text3:
                      'Adicione cinco fotos ou mais, alem de um titulo e uma descrição. Nós ajudaremos você'),
              SizedBox(height: 28),
              NewWidget(
                iconData: Icons.people,
                text1: '3.',
                text2: 'Concluir e publicar',
                text3:
                    'Escolha se voce gostaria de começar com um hospede experiente, defina um preço inciial, publique seu anuncio',
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 69, vertical: 40),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TipoEspaco(),
                ),
              ),
              child: GestureDetector(
                key: Keys.kFirstScreenButton,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TipoEspaco(),
                  ),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                  alignment: Alignment.center,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff9747FF),
                        Color(0xff44300b1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: const Text(
                    'Começar',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  final String text1;
  final String text2;
  final String text3;
  final IconData iconData;
  const NewWidget({
    super.key,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Image.asset('lib/assets/images/Rectangle 108imageBehind.png'),
              decContainer(
                //topPadding: 5,
                bottomPadding: 5,
                leftPadding: 23,
                rightPadding: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          text1,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          text2,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: const Color(0xffF3F3F3),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(iconData),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    Text(
                      text3,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
