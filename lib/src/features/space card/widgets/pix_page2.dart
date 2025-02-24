import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PixPage2 extends StatefulWidget {
  const PixPage2({super.key});

  @override
  State<PixPage2> createState() => _PixPage2State();
}

class _PixPage2State extends State<PixPage2> {
  late Timer _timer;
  int _remainingSeconds = 600;
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 18.0),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  child: Image.asset(
                'lib/assets/images/logo_pix.png',
                width: 70,
              )),
              const SizedBox(height: 10),
              const Align(
                child: Text(
                  'Finalize seu pagamento realizando o Pix',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 5),
              const Align(child: Text('Pague a vista e com poucos cliques')),
              const SizedBox(height: 10),
              Align(
                child: QrImageView(
                  data: 'This is a simple QR code',
                  size: 150,
                  gapless: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "A chave pix expira em:",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      _formatDuration(_remainingSeconds),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '000020101021226850014br.gov.bcb2580qrco...',
                          style: TextStyle(fontSize: 11),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                            onTap: () async {
                              await Clipboard.setData(const ClipboardData(
                                  text: 'ghsg6sdg6sg67d6g7s6hg79sdg67sd6gh'));
                            },
                            child: const Icon(Icons.copy))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(const ClipboardData(
                            text: 'ghsg6sdg6sg67d6g7s6hg79sdg67sd6gh'));
                      },
                      child: Container(
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
                            'Pix Copia e Cola',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "[Instruções Adicionais]",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "1. Copie a Chave Pix: Utilize o botão “Copiar chave Pix” para copiar a chave Pix aleatória.",
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              const Text(
                "2. Acesse o Seu Banco: Abra o aplicativo do seu banco e selecione a opção de pagamento via Pix.",
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              const Text(
                "3. Cole a Chave Pix: Cole a chave copiada na área indicada para chave Pix e confirme o pagamento.",
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              const Text(
                "4. Confirmação Automática: Após a realização do pagamento, a confirmação será feita automaticamente. Aguarde alguns instantes.",
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              const Text(
                "5. Certifique-se de realizar o pagamento dentro do prazo de validade da chave para evitar a perda da reserva.",
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              const Text(
                "6. O prazo de validade para pagamento da chave Pix é de 10 minutos.",
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              const Text(
                "7. Em caso de expiração do prazo, sem ter concluído o pagamento, será necessário realizar uma nova reserva.",
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 36),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
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
                      'Sair',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
