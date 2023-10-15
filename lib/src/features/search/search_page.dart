import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }


  void _onTextChanged() {
    setState(() {}); // isso irá reconstruir o widget toda vez que o texto mudar
  }

  @override
  Widget build(BuildContext context) {
    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: _buildSearchBox(x, y),
        actions: [
          TextButton(
            onPressed: () {
              // Ação ao clicar em "Cancelar"
            },
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.purple[300],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(width: x * 0.03,)
        ],
      ),
      body: Container(
        // add outros elementos se necessário
      ),
    );
  }

  Widget _buildSearchBox(double x, double y) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: x * 0.02, vertical: y * 0.01),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.purple[300]),
          const SizedBox(width: 10.0),
          Expanded(
            child: Stack(
              children: [
                _controller.text.isEmpty
                    ? RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.blueGrey[500]),
                          children: const <TextSpan>[
                            TextSpan(text: 'Buscar no '),
                            TextSpan(text: 'Festou', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ) : Container(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Buscar no Festou',
                          hintStyle: TextStyle(color: Colors.transparent),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        ),
                        style: TextStyle(color: Colors.blueGrey[900], fontSize: 12),
                        cursorColor: Colors.blueGrey[900],
                      ),
                    ),
                    Visibility(
                      visible: _controller.text.isNotEmpty,
                      child: IconButton(
                        icon: Icon(Icons.clear, color: Colors.blueGrey[900], size: 14),
                        onPressed: () => _controller.clear(),
                        padding: EdgeInsets.zero
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
