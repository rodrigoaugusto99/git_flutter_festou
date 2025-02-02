import 'package:flutter/material.dart';

class FeedbacksPanel extends StatefulWidget {
  final ValueChanged<String> onNotePressed;
  final String text;
  final List<String> selectedNotes;

  const FeedbacksPanel({
    super.key,
    required this.onNotePressed,
    required this.text,
    required this.selectedNotes,
  });

  @override
  _FeedbacksPanelState createState() => _FeedbacksPanelState();
}

class _FeedbacksPanelState extends State<FeedbacksPanel> {
  late String selectedNote;

  @override
  void initState() {
    super.initState();
    // Define o maior valor da lista selecionada como o estado inicial
    selectedNote = widget.selectedNotes.isNotEmpty
        ? '${widget.selectedNotes.map((e) => double.parse(e.replaceAll('+', ''))).reduce((a, b) => a < b ? a : b)}+'
        : '0+';
  }
  //String selectedNote = '0+';

  void updateSelectedNote(String note) {
    setState(() {
      selectedNote = note;
      widget.onNotePressed(note);
    });
  }

  bool isButtonActive(String note) {
    // Extract the numeric part of the note and compare
    double selectedValue = double.parse(selectedNote.replaceAll('+', ''));
    double noteValue = double.parse(note.replaceAll('+', ''));
    return noteValue >= selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonDay(
                  label: '1+',
                  isActive: isButtonActive('1'),
                  onNotePressed: updateSelectedNote,
                  color: Colors.red,
                ),
                ButtonDay(
                  label: '2+',
                  isActive: isButtonActive('2'),
                  onNotePressed: updateSelectedNote,
                  color: Colors.orange,
                ),
                ButtonDay(
                  label: '3+',
                  isActive: isButtonActive('3'),
                  onNotePressed: updateSelectedNote,
                  color: const Color.fromARGB(255, 108, 209, 112),
                ),
                ButtonDay(
                  label: '4+',
                  isActive: isButtonActive('4'),
                  onNotePressed: updateSelectedNote,
                  color: Colors.green,
                ),
                ButtonDay(
                  label: '5+',
                  isActive: isButtonActive('5'),
                  onNotePressed: updateSelectedNote,
                  color: const Color.fromARGB(255, 9, 134, 13),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ButtonDay extends StatelessWidget {
  final String label;
  final Color color;
  final bool isActive;
  final ValueChanged<String> onNotePressed;

  const ButtonDay({
    super.key,
    required this.label,
    required this.color,
    required this.isActive,
    required this.onNotePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onNotePressed(label),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isActive ? color : Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
