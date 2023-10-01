import 'package:flutter/material.dart';
import '../model/my_card.dart';

void clearFilter(bool isFilteredParam, VoidCallback setStateCallbackParam) {
  setStateCallbackParam();
  isFilteredParam = false; // Definir como false para remover os filtros
}

void showFilterAlertDialog(
    BuildContext context,
    VoidCallback setStateCallback,
    List<MyCard> filteredCardsParam,
    List<MyCard> myCardsParam,
    bool isFilteredParam) {
  List<String> filterTypes = [
    'Casa',
    'Apartamento',
    'Chácara',
    'Salão',
  ];
  String spaceTypeToSearch = 'Casa'; // Valor inicial do DropdownButton

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Filtrar por Tipo de Espaço'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selecione o Tipo de Espaço:'),
            DropdownButton<String>(
              value: spaceTypeToSearch,
              onChanged: (String? newValue) {
                spaceTypeToSearch =
                    newValue!; // Atualizar a variável diretamente
              },
              items: filterTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Aqui você pode realizar a filtragem da lista de cards
              // com base no spaceTypeToSearch ou qualquer outro atributo que desejar
              applyFilter(spaceTypeToSearch, setStateCallback,
                  filteredCardsParam, myCardsParam, isFilteredParam);
              Navigator.of(context).pop();
            },
            child: const Text('Filtrar'),
          ),
        ],
      );
    },
  );
}

void applyFilter(
    String spaceType,
    VoidCallback setStateCallback,
    List<MyCard> filteredCardsParam,
    List<MyCard> myCardsParam,
    bool isFilteredParam) {
  setStateCallback();
  if (spaceType.isNotEmpty) {
    filteredCardsParam = myCardsParam
        .where((card) => card.selectedSpaceType == spaceType)
        .toList();
    isFilteredParam = true; // Definir como true quando há um filtro aplicado
  } else {
    filteredCardsParam = []; // Limpar a lista de cards filtrados
    isFilteredParam = false; // Definir como false quando não há filtro aplicado
  }
}
