import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;

  const MessageTile({
    super.key,
    required this.message,
    required this.sender,
    required this.sentByMe,
  });

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: widget.sentByMe
          ? const EdgeInsets.only(top: 4, bottom: 4, left: 120, right: 10)
          : const EdgeInsets.only(top: 4, bottom: 4, right: 120, left: 10),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.sentByMe
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.onInverseSurface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.sentByMe ? const SizedBox(height: 0) : Text(widget.sender),
          Text(
            widget.message,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
