import 'dart:io';

import 'package:chat_app/main.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/chat_room.dart';
import '../../models/usermodel.dart';

// ignore: must_be_immutable
class NewMessages extends StatefulWidget {
  UserModel targetUser;
  ChatRoom chatRoom;
  UserModel user;

  NewMessages(
      {super.key,
      required this.chatRoom,
      required this.targetUser,
      required this.user});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  var newmsg = '';
  final msg = TextEditingController();
  final key = GlobalKey<FormState>();
  MessageModel? messageModel;

  void ontap(BuildContext context) async {
    if (key.currentState!.validate() || msg.text.isNotEmpty) {
      msg.clear();

      MessageModel messageModelText = MessageModel(
        messageid: uuid.v1(),
        sender: widget.user.uid,
        text: newmsg,
        createdon: DateTime.now(),
        seen: false,
        msgType: "text",
      );

      await FirebaseFirestore.instance
          .collection("chatroom")
          .doc(widget.chatRoom.chatId)
          .collection("messages")
          .doc(messageModelText.messageid)
          .set(messageModelText.toMap());

      widget.chatRoom.lastMsg = newmsg;

      FirebaseFirestore.instance
          .collection("chatroom")
          .doc(widget.chatRoom.chatId)
          .update({
        'lastMsg': widget.chatRoom.lastMsg,
      });
    }
  }

  void selectImage() async {
    XFile? file;

    file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    TaskSnapshot taskSnapshot = await FirebaseStorage.instance
        .ref("ChatRoom Image")
        .child(widget.chatRoom.chatId!)
        .child(widget.user.uid!)
        .child("images")
        .child(uuid.v1())
        .putFile(File(file!.path));

    var getImageUrl = await taskSnapshot.ref.getDownloadURL();
    print(getImageUrl);

    MessageModel messageModelImage = MessageModel(
      messageid: uuid.v1(),
      sender: widget.user.uid,
      text: getImageUrl,
      createdon: DateTime.now(),
      seen: false,
      msgType: "img",
    );

    await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(widget.chatRoom.chatId)
        .collection("messages")
        .doc(messageModelImage.messageid)
        .set(messageModelImage.toMap());
  }

  void selectDoc() async {
    String? doc = await FlutterDocumentPicker.openDocument();
    if (doc!.isNotEmpty) {
      File file = File(doc);

      TaskSnapshot taskSnapshot = await FirebaseStorage.instance
          .ref("ChatRoom Image")
          .child(widget.chatRoom.chatId!)
          .child(widget.user.uid!)
          .child("pdf")
          .child(uuid.v1())
          .putData(
            await file.readAsBytes(),
            SettableMetadata(
              contentType: 'file/pdf',
              customMetadata: {'picked-path': file.path},
            ),
          );

      var url = await taskSnapshot.ref.getDownloadURL();

      MessageModel messageModelPdf = MessageModel(
        messageid: uuid.v1(),
        sender: widget.user.uid,
        text: url,
        createdon: DateTime.now(),
        seen: false,
        msgType: "pdf",
      );

      FirebaseFirestore.instance
          .collection("chatroom")
          .doc(widget.chatRoom.chatId)
          .collection("messages")
          .doc(messageModelPdf.messageid)
          .set(messageModelPdf.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => selectImage(),
            icon: const Icon(Icons.insert_photo_outlined),
          ),
          IconButton(
            onPressed: () => selectDoc(),
            icon: const Icon(Icons.file_present_outlined),
          ),
          Expanded(
            child: Form(
              key: key,
              child: TextFormField(
                controller: msg,
                decoration: const InputDecoration(
                  label: Text("send Message"),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter msg";
                  }
                  return null;
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
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
