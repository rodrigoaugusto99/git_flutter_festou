import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final Widget message;
  final bool isCurrentUser;
  final bool isSelected;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected ? Colors.black.withOpacity(0.1) : Colors.transparent,
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: isCurrentUser
                ? const Color(0xFF9747FF)
                : const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 25),
          child: message,
        ),
      ),
    );
  }
}
