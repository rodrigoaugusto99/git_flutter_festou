import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/pages/tipo_espaco.dart';

class DescrevaAcomodacao extends StatefulWidget {
  const DescrevaAcomodacao({super.key});

  @override
  State<DescrevaAcomodacao> createState() => _DescrevaAcomodacaoState();
}

class _DescrevaAcomodacaoState extends State<DescrevaAcomodacao> {
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
          const Column(
            children: [
              Text(
                'Etapa 1',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Descreva sua acomodação',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'Nessa etapa, perguntaremos que tipo de propriedade voce deseja anunciar e se os hospedes poderao reservar o espalo inteiro ou apewnas um quarto. em seguida, informe a loicalizacao e quantas pessaos podem sse hospedar',
              ),
            ],
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
                      builder: (context) => const TipoEspaco(),
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
