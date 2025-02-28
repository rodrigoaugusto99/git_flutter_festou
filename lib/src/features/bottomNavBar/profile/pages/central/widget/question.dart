import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  final String text;
  final String response;

  const QuestionWidget({
    super.key,
    required this.text,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showQuestionDialog(context, text, response);
      },
      child: Container(
        alignment: Alignment.center,
        height: 107,
        width: 143,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: const Color(0xffF0F0F0),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _showQuestionDialog(
      BuildContext context, String question, String answer) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pergunta em destaque
              Text(
                question,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Resposta com espaçamento e formatação melhor
              Text(
                answer,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5, // Melhor espaçamento entre linhas
                ),
              ),
              const SizedBox(height: 20),

              // Botão estilizado
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple, // Cor do botão
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    'Ok',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
