import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/tipo_espaco.dart';

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
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              children: [
                Text(
                  'É muito facil anunciar no Festou!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                NewWidget(
                  text1: '1',
                  text2: 'Descreva sua\nacomodação',
                  text3:
                      'Compartilhe algumas informacoes basicas, como a localizaçao e quantos hospedes podem ficar no local',
                ),
                SizedBox(height: 15),
                Divider(thickness: 2),
                SizedBox(height: 15),
                NewWidget(
                    text1: '2',
                    text2: 'Faça com que se\ndestaque',
                    text3:
                        'Adicione cinco fotos ou mais, alem de um titulo e uma descrição. Nós ajudaremos você'),
                SizedBox(height: 15),
                Divider(thickness: 2),
                SizedBox(height: 15),
                NewWidget(
                  text1: '3',
                  text2: 'Concluir e publicar',
                  text3:
                      'Escolha se voce gostaria de começar com um hospede experiente, defina um preço inciial, publique seu anuncio',
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TipoEspaco(),
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(),
                  ),
                  child: const Text('Começar'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  final String text1;
  final String text2;
  final String text3;
  const NewWidget({
    super.key,
    required this.text1,
    required this.text2,
    required this.text3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text1,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text2,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(text3),
            ],
          ),
        ),
        const Expanded(
          child: Icon(Icons.reduce_capacity),
        ),
      ],
    );
  }
}
