import 'package:chat_app/auth/auth_services.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import '../pdf_view_screen.dart';
import 'show_image.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.msg, this.targetUser, this.currentUser);

  final MessageModel msg;

  final UserModel targetUser;
  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    var isMe = msg.sender;
    final PDFView doc = PDFView(
      filePath: msg.text,
    );
    return Row(
      mainAxisAlignment: isMe == AuthService.authService.auth.currentUser!.uid
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe == AuthService.authService.auth.currentUser!.uid
                    ? Colors.grey
                    : Colors.amber,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft:
                      isMe != AuthService.authService.auth.currentUser!.uid
                          ? const Radius.circular(0)
                          : const Radius.circular(12),
                  bottomRight:
                      isMe == AuthService.authService.auth.currentUser!.uid
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isMe != AuthService.authService.auth.currentUser!.uid
                        ? targetUser.username.toString()
                        : currentUser.username.toString(),
                  ),
                  if (msg.msgType == "text")
                    Text(msg.text!)
                  else if (msg.msgType == "img")
                    InkWell(
                      onTap: () => Get.to(() => ShowImage(image: msg.text)),
                      child: Image.network(
                        msg.text!,
                        width: 100,
                        height: 200,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () => Get.to(() => PdfViewScreen(msg.text!)),
                      child: Text(msg.msgType!),
                    ),
                  Container(
                    width: 100,
                    child: Text(
                      "${msg.createdon!.hour.toString()} : ${msg.createdon!.minute.toString()}",
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
