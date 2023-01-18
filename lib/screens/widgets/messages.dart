import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/chat_room.dart';
import '../../models/usermodel.dart';
import 'message_bubble.dart';

class Messages extends StatelessWidget {
  UserModel targetUser;
  ChatRoom chatRoom;
  UserModel user;

  Messages(
      {required this.chatRoom, required this.targetUser, required this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chatroom")
          .doc(chatRoom.chatId)
          .collection("messages")
          .orderBy("createdon", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          QuerySnapshot data = snapshot.data as QuerySnapshot;
          return ListView.builder(
            reverse: true,
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              MessageModel messageModel = MessageModel.fromMap(
                  data.docs[index].data() as Map<String, dynamic>);
              print(messageModel.createdon);
              return MessageBubble(messageModel, messageModel.sender!);
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
