import 'package:flutter/material.dart';

class EditTextDialog extends StatefulWidget {
  final String initialText;
  const EditTextDialog({
    super.key,
    required this.initialText,
  });

  @override
  State<EditTextDialog> createState() => _EditTextDialogState();
}

class _EditTextDialogState extends State<EditTextDialog> {
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar Texto"),
      content: SingleChildScrollView(
        child: TextField(
          controller: textController,
          maxLines: 5,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(textController.text);
          },
          child: const Text("Editar"),
        ),
      ],
    );
  }
}
