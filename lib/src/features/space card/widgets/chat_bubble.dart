import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final Widget message;
  final bool isCurrentUser;
  final bool isSelected;
  final String timestamp;
  final bool isSeen;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.isSelected,
    required this.timestamp,
    required this.isSeen,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              message,
              const SizedBox(height: 5),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timestamp,
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white70 : Colors.black54,
                      fontSize: 11,
                    ),
                  ),
                  if (isCurrentUser) ...[
                    const SizedBox(width: 5),
                    Image.asset(
                      isSeen
                          ? 'lib/assets/images/icon_double_check.png'
                          : 'lib/assets/images/icon_check.png',
                      width: 16,
                      height: 16,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
