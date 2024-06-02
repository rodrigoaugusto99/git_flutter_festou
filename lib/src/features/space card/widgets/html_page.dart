import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlPage extends StatelessWidget {
  final String html;

  const HtmlPage({super.key, required this.html});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Html(
              data: html,
              style: {
                'body': Style(
                  fontSize: FontSize(12.0),
                ),
                'p': Style(
                  margin: Margins.only(
                    bottom: 8,
                  ),
                ),
                'h2': Style(
                  color: const Color(0xff304571),
                  margin: Margins.only(
                    bottom: 0,
                  ),
                ),
              },
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Voltar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Assinar de novo'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
