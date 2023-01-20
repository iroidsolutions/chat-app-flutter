import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chat_room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/usermodel.dart';
import 'widgets/messages.dart';
import 'widgets/new_messages.dart';

class ChatScreen extends StatefulWidget {
  UserModel targetUser;
  ChatRoom chatRoom;
  UserModel user;

  ChatScreen(
      {required this.chatRoom, required this.targetUser, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CachedNetworkImage(
              imageUrl: widget.targetUser.profile!,
              imageBuilder: (context, imageProvider) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(widget.targetUser.username!),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Messages(
              targetUser: widget.targetUser,
              user: widget.user,
              chatRoom: widget.chatRoom,
            ),
          ),
          NewMessages(
            targetUser: widget.targetUser,
            user: widget.user,
            chatRoom: widget.chatRoom,
          ),
        ],
      ),
    );
  }
}
