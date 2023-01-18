import 'package:chat_app/main.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../../models/chat_room.dart';
import '../../models/usermodel.dart';

class NewMessages extends StatefulWidget {
  UserModel targetUser;
  ChatRoom chatRoom;
  UserModel user;

  NewMessages(
      {required this.chatRoom, required this.targetUser, required this.user});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  var newmsg = '';
  final msg = TextEditingController();
  final key = GlobalKey<FormState>();

  void ontap(BuildContext context) async {
    if (key.currentState!.validate() || msg.text.isNotEmpty) {
      msg.clear();

      MessageModel messageModel = MessageModel(
        messageid: uuid.v1(),
        sender: widget.user.uid,
        text: newmsg,
        createdon: DateTime.now(),
        seen: false,
      );

      await FirebaseFirestore.instance
          .collection("chatroom")
          .doc(widget.chatRoom.chatId)
          .collection("messages")
          .doc(messageModel.messageid)
          .set(messageModel.toMap());

      CollectionReference collectionReference = FirebaseFirestore.instance
          .collection("chatroom")
          .doc()
          .collection("messages");

      Future future = collectionReference.doc(messageModel.messageid).get();
      future.then((value) {
        print(value);
      });

      collectionReference.doc(messageModel.messageid).get().then((value) {
        Map<String, dynamic> map = value.data() as Map<String, dynamic>;

        MessageModel messageModel = MessageModel.fromMap(map);
        var lastmsg = messageModel.text!;
        FirebaseFirestore.instance
            .collection("chatroom")
            .doc(widget.chatRoom.chatId)
            .update({
          'lastMsg': lastmsg,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
      child: Row(
        children: [
          Expanded(
            child: Form(
              key: key,
              child: TextFormField(
                controller: msg,
                decoration: const InputDecoration(label: Text("send Message")),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter msg";
                  }
                },
                onChanged: (value) {
                  setState(() {
                    newmsg = value;
                  });
                },
              ),
            ),
          ),
          IconButton(
              onPressed: newmsg.trim().isEmpty ? null : () => ontap(context),
              icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
