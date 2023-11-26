import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/pages/revisao.dart';

class UltimaEtapa extends StatefulWidget {
  const UltimaEtapa({super.key});

  @override
  State<UltimaEtapa> createState() => _UltimaEtapaState();
}

class _UltimaEtapaState extends State<UltimaEtapa> {
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
          Column(
            children: [
              const Text(
                'falta só mais uma etapa!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Sua acomodacao tea algumas dessas opçoes?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Text('camera de segurança'),
              const Text('armas'),
              const Text('animais perigosos'),
              const SizedBox(height: 10),
              const Divider(thickness: 0.4, color: Colors.grey),
              const SizedBox(height: 10),
              const Text('O que é mais importante saber?'),
              Wrap(
                children: [
                  const Text('Confirme se voce cumpre as '),
                  MyText('leis locais '),
                  const Text(' e consulte a'),
                  MyText(' Politica de Não Discriminação do Festou '),
                  const Text('e as '),
                  MyText('taxas de hóspedes.'),
                ],
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

  Widget MyText(String text) {
    return Text(
      text,
      style: const TextStyle(
          decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
    );
  }
}
