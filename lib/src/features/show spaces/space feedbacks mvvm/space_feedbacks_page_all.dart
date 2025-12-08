import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festou/src/models/avaliacoes_model.dart';
import 'package:festou/src/services/avaliacoes_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festou/src/features/loading_indicator.dart';
import 'package:festou/src/features/space%20card/widgets/new_feedback_widget_all.dart';
import 'package:festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_state.dart';
import 'package:festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_vm.dart';
import 'package:festou/src/models/space_model.dart';

class SpaceFeedbacksPageAll extends StatefulWidget {
  final SpaceModel space;
  final List<AvaliacoesModel> feedbacks;

  const SpaceFeedbacksPageAll({
    super.key,
    required this.space,
    required this.feedbacks,
  });

  @override
  State<SpaceFeedbacksPageAll> createState() => _SpaceFeedbacksPageAllState();
}

var selectedOption = 'date';
var selectedOptionName = 'Mais recentes';

class _SpaceFeedbacksPageAllState extends State<SpaceFeedbacksPageAll> {
  @override
  void initState() {
    super.initState();
    getFeedbacksOrdered();
  }

  List<AvaliacoesModel> avaliacoes = [];

  Future<void> getFeedbacksOrdered() async {
    try {
      QuerySnapshot allFeedbacksDocuments = await FirebaseFirestore.instance
          .collection('feedbacks')
          .where('space_id', isEqualTo: widget.space.spaceId)
          .orderBy('date', descending: true)
          .get();

      List<AvaliacoesModel> feedbackModels =
          allFeedbacksDocuments.docs.map((feedbackDocument) {
        return AvaliacoesService().mapFeedbackDocumentToModel(feedbackDocument);
      }).toList();
      avaliacoes = feedbackModels;
      setState(() {});
    } catch (e) {
      log('Erro ao recuperar os feeedbacks do firestore: $e');
      avaliacoes = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${avaliacoes.length} comentários',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      _showSortOptionsDialog();
                    },
                    child: Row(
                      children: [
                        Text(
                          selectedOptionName,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: NewFeedbackWidgetAll(
              //data: data,

              feedbacks: avaliacoes,
            ),
          ),
        ],
      ),
    );
  }

  void _showSortOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ordenar por',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              RadioListTile(
                title: const Text('Mais recentes'),
                value: 'date',
                groupValue: selectedOption,
                onChanged: (value) =>
                    _applySorting(value as String, 'Mais recentes'),
              ),
              RadioListTile(
                title: const Text('Avaliações mais altas'),
                value: 'highest',
                groupValue: selectedOption,
                onChanged: (value) =>
                    _applySorting(value as String, 'Avaliações mais altas'),
              ),
              RadioListTile(
                title: const Text('Avaliações mais baixas'),
                value: 'lowest',
                groupValue: selectedOption,
                onChanged: (value) =>
                    _applySorting(value as String, 'Avaliações mais baixas'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _applySorting(String option, String optionName) {
    setState(() {
      selectedOption = option;
      selectedOptionName = optionName;
      _sortFeedbacks();
    });
    Navigator.pop(context);
  }

  void _sortFeedbacks() {
    setState(() {
      if (selectedOption == 'date') {
        avaliacoes
            .sort((a, b) => _parseDate(b.date).compareTo(_parseDate(a.date)));
      } else if (selectedOption == 'highest') {
        avaliacoes.sort((a, b) => (b.likes.length - b.dislikes.length)
            .compareTo(a.likes.length - a.dislikes.length));
      } else if (selectedOption == 'lowest') {
        avaliacoes.sort((a, b) => (a.likes.length - a.dislikes.length)
            .compareTo(b.likes.length - b.dislikes.length));
      }
    });
  }

  DateTime _parseDate(String date) {
    List<String> parts = date.split('/');
    return DateTime(
        int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  }
}
