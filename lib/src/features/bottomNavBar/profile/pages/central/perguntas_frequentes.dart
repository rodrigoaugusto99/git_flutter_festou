import 'package:flutter/material.dart';

class PerguntasFrequentes extends StatefulWidget {
  final List<Map<String, dynamic>> perguntas;

  const PerguntasFrequentes({super.key, required this.perguntas});

  @override
  State<PerguntasFrequentes> createState() => _PerguntasFrequentesState();
}

class _PerguntasFrequentesState extends State<PerguntasFrequentes>
    with TickerProviderStateMixin {
  List<bool> _expandedStates = [];
  late List<AnimationController> _controllers;
  late List<Animation<double>> _heightAnimations;

  @override
  void initState() {
    super.initState();
    _expandedStates = List.generate(widget.perguntas.length, (index) => false);

    // Inicializa animações individuais para cada item da lista
    _controllers = List.generate(
      widget.perguntas.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );

    _heightAnimations = _controllers
        .map((controller) => CurvedAnimation(
              parent: controller,
              curve: Curves.easeInOut,
            ))
        .toList();
  }

  void _toggleExpansion(int index) {
    setState(() {
      if (_expandedStates[index]) {
        _controllers[index].reverse(); // Recolhe com animação
      } else {
        _controllers[index].forward(); // Expande com animação
      }
      _expandedStates[index] = !_expandedStates[index];
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ListView.builder(
          itemCount: widget.perguntas.length,
          itemBuilder: (context, index) {
            final question = widget.perguntas[index]['question'];
            final response = widget.perguntas[index]['response'];

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      question,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    trailing: AnimatedRotation(
                      turns: _expandedStates[index] ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(Icons.keyboard_arrow_down),
                    ),
                    onTap: () => _toggleExpansion(index),
                  ),
                  SizeTransition(
                    sizeFactor: _heightAnimations[index],
                    axisAlignment: -1.0, // Alinha a expansão de forma natural
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: Text(
                        response,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
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
