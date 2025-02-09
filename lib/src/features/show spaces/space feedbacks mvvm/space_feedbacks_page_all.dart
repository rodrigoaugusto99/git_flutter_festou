import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Festou/src/features/loading_indicator.dart';
import 'package:Festou/src/features/space%20card/widgets/new_feedback_widget_all.dart';
import 'package:Festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_state.dart';
import 'package:Festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_vm.dart';
import 'package:Festou/src/models/space_model.dart';

class SpaceFeedbacksPageAll extends ConsumerStatefulWidget {
  final SpaceModel space;

  const SpaceFeedbacksPageAll({
    super.key,
    required this.space,
  });

  @override
  ConsumerState<SpaceFeedbacksPageAll> createState() =>
      _SpaceFeedbacksPageAllState();
}

var selectedOption = 'date';
var selectedOptionName = 'Mais recentes';

class _SpaceFeedbacksPageAllState extends ConsumerState<SpaceFeedbacksPageAll> {
  @override
  Widget build(BuildContext context) {
    final spaceFeedbacks =
        ref.watch(spaceFeedbacksVmProvider(widget.space, selectedOption));

    return spaceFeedbacks.when(
      data: (SpaceFeedbacksState data) {
        if (data.feedbacks.isEmpty) {
          return const Center(
            child: Text('Sem avaliações(ainda)'),
          );
        }
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
                      '${widget.space.numComments} comentários',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 2),
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
                  data: data,
                  spaces: spaceFeedbacks,
                ),
              ),
            ],
          ),
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return const Stack(children: [
          Center(child: Icon(Icons.error)),
        ]);
      },
      loading: () {
        return const Stack(children: [
          Center(child: CustomLoadingIndicator()),
        ]);
      },
    );
  }

  void _showSortOptionsDialog() {
    String tempSelectedOption = selectedOption; // Estado temporário
    String tempSelectedOptionName = selectedOptionName; // Estado temporário
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, thisSetState) {
              return SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Ordenar por',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text('Mais recentes'),
                        ),
                        Radio(
                          value: 'date',
                          groupValue: tempSelectedOption,
                          onChanged: (value) {
                            thisSetState(() {
                              tempSelectedOption = value as String;
                              tempSelectedOptionName = 'Mais recentes';
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text('Avaliações mais altas'),
                        ),
                        Radio(
                          value: 'rating',
                          groupValue: tempSelectedOption,
                          onChanged: (value) {
                            thisSetState(() {
                              tempSelectedOption = value as String;
                              tempSelectedOptionName = 'Avaliações mais altas';
                            });
                          },
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 0.9,
                      color: Colors.grey,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedOption = tempSelectedOption;
                          selectedOptionName = tempSelectedOptionName;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Text(
                          'Salvar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    ).then((_) {
      // Chame o método build novamente após a seleção da opção.
      ref.read(spaceFeedbacksVmProvider(widget.space, selectedOption));
    });
  }
}
