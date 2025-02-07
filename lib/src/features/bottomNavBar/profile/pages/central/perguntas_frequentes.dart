import 'package:flutter/material.dart';

class PerguntasFrequentes extends StatefulWidget {
  final List<Map<String, dynamic>> perguntas;

  const PerguntasFrequentes({super.key, required this.perguntas});

  @override
  State<PerguntasFrequentes> createState() => _PerguntasFrequentesState();
}

class _PerguntasFrequentesState extends State<PerguntasFrequentes> {
  List<bool> _expandedStates = [];

  @override
  void initState() {
    super.initState();
    _expandedStates = List.generate(widget.perguntas.length, (index) => false);
  }

  void _toggleExpansion(int index) {
    setState(() {
      _expandedStates[index] = !_expandedStates[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
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
        ),
        centerTitle: true,
        title: const Text(
          'Perguntas Frequentes',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: widget.perguntas.length,
          itemBuilder: (context, index) {
            final question = widget.perguntas[index]['question'];
            final response = widget.perguntas[index]['response'];

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      question,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      _expandedStates[index]
                          ? Icons.keyboard_arrow_up // Ícone recolhido (^)
                          : Icons.keyboard_arrow_down, // Ícone expandido (v)
                      color: Colors.black,
                    ),
                    onTap: () => _toggleExpansion(index),
                  ),
                  if (_expandedStates[
                      index]) // Exibe a resposta quando expandido
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: Text(
                        response,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
