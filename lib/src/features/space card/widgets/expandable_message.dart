import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Festou/src/features/space%20card/widgets/chat_bubble.dart';

class ExpandableMessage extends StatefulWidget {
  final String message;
  final bool isCurrentUser;
  final bool isSelected;
  final String timestamp;
  final bool isSeen;

  const ExpandableMessage({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.isSelected,
    required this.timestamp,
    required this.isSeen,
  });

  @override
  _ExpandableMessageState createState() => _ExpandableMessageState();
}

class _ExpandableMessageState extends State<ExpandableMessage> {
  int maxLength = 500;

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      message: _buildMessage(widget.message),
      isCurrentUser: widget.isCurrentUser,
      isSelected: widget.isSelected,
      timestamp: widget.timestamp,
      isSeen: widget.isSeen,
    );
  }

  bool isSingleEmoji(String message) {
    RegExp singleEmojiRegex = RegExp(
      r'^(?:'
      r'[\u2700-\u27BF]|'
      r'[\u1F300-\u1F5FF]|'
      r'[\u1F600-\u1F64F]|'
      r'[\u1F680-\u1F6FF]|'
      r'[\u1F700-\u1F77F]|'
      r'[\u1F780-\u1F7FF]|'
      r'[\u1F800-\u1F8FF]|'
      r'[\u1F900-\u1F9FF]|'
      r'[\u1FA00-\u1FA6F]|'
      r'[\u1FA70-\u1FAFF]|'
      r'[\u1FB00-\u1FBFF]|'
      r'[\u1FC00-\u1FCFF]|'
      r'[\u1FD00-\u1FDFF]|'
      r'[\u1FE00-\u1FEFF]|'
      r'[\u1FF00-\u1FFFF]|'
      r'[\u2600-\u26FF]|'
      r'[\u2702-\u27B0]|'
      r'[\u1F1E6-\u1F1FF]|'
      r'\uD83C[\uDDE6-\uDDFF]|'
      r'[\uD83D\uDC00-\uD83D\uDE4F]|'
      r'[\uD83D\uDE80-\uD83D\uDEF6]|'
      r'[\uD83E\uDD00-\uD83E\uDDFF]|'
      r'[\uD83E\uDE00-\uD83E\uDE4F]|'
      r'[\uD83E\uDE80-\uD83E\uDEFF]|'
      r'[\uD83C\uDF00-\uD83D\uDDFF]|'
      r'[\uD83C\uDDE6-\uD83C\uDDFF]{2}|'
      r'\uD83C\uDFF3\uFE0F\u200D\uD83C\uDF08|'
      r'\u261D|'
      r'\u26F9|'
      r'\u270A|'
      r'\u270B|'
      r'\u270C|'
      r'\u270D|'
      r'[\u2B05-\u2B07]|'
      r'[\u2934-\u2935]|'
      r'[\u2B06-\u2B07]|'
      r'[\u3297-\u3299]|'
      r'[\u25AA-\u25AB]|'
      r'[\u25FB-\u25FE]'
      r')$',
      unicode: true,
    );
    return singleEmojiRegex.hasMatch(message);
  }

  List<InlineSpan> _parseMessage(String message) {
    List<InlineSpan> spans = [];
    RegExp emojiRegex = RegExp(
      r'([\u2700-\u27BF]|[\u1F300-\u1F5FF]|[\u1F600-\u1F64F]|[\u1F680-\u1F6FF]|[\u1F700-\u1F77F]|[\u1F780-\u1F7FF]|[\u1F800-\u1F8FF]|[\u1F900-\u1F9FF]|[\u1FA00-\u1FA6F]|\u{1F1E6}-\u{1F1FF}|\u{1F3FB}-\u{1F3FF}|\u{1F3F4}-\u{1F3F4}\u{E0067}-\u{E007F}|\u{E0067}-\u{E007F}|[\u1F1E6-\u1F1FF])+',
      unicode: true,
    );

    bool singleEmoji = isSingleEmoji(message);

    message.splitMapJoin(
      emojiRegex,
      onMatch: (Match match) {
        spans.add(TextSpan(
          text: match.group(0),
          style: TextStyle(
              color: widget.isCurrentUser ? Colors.white : Colors.black,
              fontSize: 16),
        ));
        return '';
      },
      onNonMatch: (String text) {
        spans.add(TextSpan(
          text: text,
          style: TextStyle(
            color: widget.isCurrentUser ? Colors.white : Colors.black,
            fontSize: singleEmoji ? 80 : 22,
          ),
        ));
        return '';
      },
    );

    return spans;
  }

  Widget _buildMessage(String message) {
    if (message.startsWith('http') && (message.endsWith('.gif'))) {
      return Image.network(message);
    } else {
      if (message.length > maxLength) {
        return RichText(
          text: TextSpan(
            children: [
              ..._parseMessage(message.substring(0, maxLength)),
              TextSpan(
                text: "... ver mais",
                style: TextStyle(
                  color: widget.isCurrentUser ? Colors.white : Colors.black,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      maxLength += 500;
                    });
                  },
              ),
            ],
          ),
        );
      } else {
        return RichText(
          text: TextSpan(
            children: _parseMessage(message),
            style: TextStyle(
              color: widget.isCurrentUser ? Colors.white : Colors.black,
            ),
          ),
        );
      }
    }
  }
}
