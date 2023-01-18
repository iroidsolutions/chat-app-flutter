import 'package:chat_app/auth/auth_services.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.msg, this.isMe);

  final MessageModel msg;
  final String isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe == AuthService.authService.auth.currentUser!.uid
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe == AuthService.authService.auth.currentUser!.uid
                ? Colors.grey
                : Colors.amber,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: isMe != AuthService.authService.auth.currentUser!.uid
                  ? const Radius.circular(0)
                  : const Radius.circular(12),
              bottomRight: isMe == AuthService.authService.auth.currentUser!.uid
                  ? const Radius.circular(0)
                  : const Radius.circular(12),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          child: Text(msg.text!),
        ),
      ],
    );
  }
}
