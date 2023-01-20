import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/auth/auth_services.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/usermodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../pdf_view_screen.dart';
import 'show_image.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.msg, this.targetUser, this.currentUser);

  final MessageModel msg;

  final UserModel targetUser;
  final UserModel currentUser;

  Future<bool> getPdf() async {
    if (await _requestPermission(Permission.storage) &&
        await _requestPermission(Permission.accessMediaLocation) &&
        // manage external storage needed for android 11/R
        await _requestPermission(Permission.manageExternalStorage)) {
      Directory? dic;

      dic = await getExternalStorageDirectory();
      String newPath = '';
      List<String> paths = dic!.path.split("/");

      for (var i = 0; i < paths.length; i++) {
        String folder = paths[i];
        if (folder != "Android") {
          newPath += "/$folder";
        } else {
          break;
        }
      }

      newPath = "$newPath/PDF_Download";
      dic = Directory(newPath);

      File saveFile = File("${dic.path}/tirth.pdf");
      print(saveFile);
      if (!await dic.exists()) {
        await dic.create(recursive: true);
      }
      if (await dic.exists()) {
        await Dio().download(
          msg.text!,
          saveFile.path,
        );
      }
    }
    return true;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      PermissionStatus permissionStatus = await permission.request();
      if (permissionStatus.isGranted) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var isMe = msg.sender;

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
                  const SizedBox(
                    height: 5,
                  ),
                  if (msg.msgType == "text")
                    Text(msg.text!)
                  else if (msg.msgType == "img")
                    InkWell(
                      onTap: () => Get.to(() => ShowImage(image: msg.text)),
                      child: CachedNetworkImage(
                        imageUrl: msg.text!,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        width: 100,
                        height: 200,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () async {
                        await getPdf();
                        Get.to(() => PdfViewScreen(msg.text!));
                      },
                      child: Text(msg.msgType!),
                    ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      "${msg.createdon!.hour.toString()} : ${msg.createdon!.minute.toString()} ",
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
