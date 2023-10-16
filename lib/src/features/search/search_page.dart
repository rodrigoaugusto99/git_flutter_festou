import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../bottomNavBar/bottomNavBarPage.dart';
import '../home/home_page.dart';

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
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: y * 0.04),
        child: FadeInUp(
          duration: const Duration(milliseconds: 400),
          from: y * 0.1,
          child: Row(
            children: [
              _buildSearchBox(x, y),
              _buildCancelButton(),
              SizedBox(
                width: x * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBox(double x, double y) {
    return Expanded(
      child: Container(
        //TODO: margin
        margin: const EdgeInsets.all(8),
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
                              TextSpan(
                                  text: 'Festou',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      : Container(
                          height: 0,
                        ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'Buscar no Festou',
                            hintStyle: TextStyle(color: Colors.transparent),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                          ),
                          style: TextStyle(
                              color: Colors.blueGrey[900], fontSize: 12),
                          cursorColor: Colors.blueGrey[900],
                        ),
                      ),
                      Visibility(
                        visible: _controller.text.isNotEmpty,
                        child: InkWell(
                          onTap: () => _controller.clear(),
                          child: Icon(
                            Icons.clear,
                            color: Colors.blueGrey[900],
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => BottomNavBarPage(previousRoute: '/home/search_page'),
      )),
      child: Text(
        'Cancelar',
        style: TextStyle(
          color: Colors.purple[300],
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
