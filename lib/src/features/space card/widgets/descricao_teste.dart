import 'package:flutter/material.dart';

class CustomDescriptionWidget extends StatefulWidget {
  final String description;

  const CustomDescriptionWidget({super.key, required this.description});

  @override
  _CustomDescriptionWidgetState createState() =>
      _CustomDescriptionWidgetState();
}

class _CustomDescriptionWidgetState extends State<CustomDescriptionWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.description,
          maxLines: isExpanded ? null : 3,
          overflow: TextOverflow.ellipsis,
        ),
        if (widget.description.length > 150) // Exemplo: 150 caracteres
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  isExpanded ? 'Ver menos' : 'Ver mais',
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(isExpanded ? Icons.arrow_upward : Icons.arrow_downward),
              ],
            ),
          ),
      ],
    );
  }
}
