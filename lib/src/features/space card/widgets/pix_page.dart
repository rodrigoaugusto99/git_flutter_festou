import 'package:flutter/material.dart';

class PixPage extends StatefulWidget {
  const PixPage({super.key});

  @override
  State<PixPage> createState() => _PixPageState();
}

class _PixPageState extends State<PixPage> {
  bool _isChecked = false;
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
          'Pix',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Align(child: Image.asset('lib/assets/images/Pix Imagepix (1).png')),
            const SizedBox(height: 20),
            const Align(
              child: Text(
                'Pix - O método de pagamento do Banco Central',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 5),
            const Align(child: Text('Pague a vista e com poucos cliques')),
            const SizedBox(height: 60),
            const Text(
              "1. A chave só é gerado ao finalizar a reserva.",
              style: TextStyle(fontSize: 12),
            ),
            const Text(
              "2. Copie a Chave Pix: Utilize o botão “copiar” para copiar a chave Pix aleatória.",
              style: TextStyle(fontSize: 12),
            ),
            const Text(
              "3. Acesse o Seu Banco: Abra o aplicativo do seu banco e selecione a opção de pagamento via Pix.",
              style: TextStyle(fontSize: 12),
            ),
            const Text(
              "4. Cole a Chave Pix: Cole a chave copiada na área indicada para chave Pix e confirme o pagamento.",
              style: TextStyle(fontSize: 12),
            ),
            const Text(
              "5. Confirmação Automática: Após a realização do pagamento, a confirmação será feita automaticamente. Aguarde alguns instantes.",
              style: TextStyle(fontSize: 12),
            ),
            const Text(
              "6. Certifique-se de realizar o pagamento dentro do prazo de validade da chave para evitar a perda da reserva.",
              style: TextStyle(fontSize: 12),
            ),
            const Text(
              "7. O prazo de validade para pagamento da chave Pix é de 5 minutos.",
              style: TextStyle(fontSize: 12),
            ),
            const Text(
              "8. Em caso de expiração do prazo, sem ter concluído o pagamento, será necessário realizar uma nova reserva.",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    side: const BorderSide(),
                    activeColor: Colors.transparent,
                    splashRadius: 0,
                    checkColor: Colors.black,
                    value: _isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    },
                  ),
                  const Text(
                    'Definir como método de pagamento principal',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
