import 'dart:developer';

import 'package:chat_app/auth/auth_services.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_room.dart';
import 'package:chat_app/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_screen.dart';

class SearchUser extends StatefulWidget {
  SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  TextEditingController controller = TextEditingController();

  var user;
  var username;
  UserModel? userModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = AuthService.authService.user.value!.uid;
    getdata();
  }

  Future getdata() async {
    CollectionReference snap = FirebaseFirestore.instance.collection("user");

    snap.doc(user).get().then((value) {
      Map<String, dynamic> snapshot = value.data() as Map<String, dynamic>;
      userModel = UserModel.fromMap(snapshot);
      username = userModel!.username;
      print(username);
    });
  }

  Future<ChatRoom?> getchatRoom(UserModel targetModel) async {
    // print(targetModel.uid);
    // print(user);
    ChatRoom? chatRoom;

    //first way
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("chatroom")
        .where("participants.${user}", isEqualTo: true)
        .where("participants.${targetModel.uid}", isEqualTo: true)
        .get();

    var doc = snapshot.docs;
    print(doc);
    if (doc.isNotEmpty) {
      print("room already created");
      var data = doc[0].data();
      ChatRoom existingRoom = ChatRoom.fromMap(data);
      chatRoom = existingRoom;
    } else {
      print("new room created");
      ChatRoom newchatroom =
          ChatRoom(chatId: uuid.v1(), lastMsg: "", participants: {
        user: true,
        targetModel.uid.toString(): true,
      });
      await FirebaseFirestore.instance
          .collection("chatroom")
          .doc(newchatroom.chatId)
          .set(newchatroom.toMap());
      log("done.....");
      chatRoom = newchatroom;
    }

    // second way
    // QuerySnapshot<Map<String, dynamic>> snapshot =
    //     await FirebaseFirestore.instance.collection("chatroom").get();
    // print(snapshot);
    // var doc = snapshot.docs;
    // print(doc);
    // var created = false;
    // for (var element in doc) {
    //   ChatRoom existsRoom = ChatRoom.fromMap(element.data());
    //   if (existsRoom.participants!.keys.contains('$user') &&
    //       existsRoom.participants!.keys.contains('${targetModel.uid}')) {
    //     log("message room already created");
    //     if (element.id.isNotEmpty) {
    //       chatRoom = existsRoom;
    //       created = true;
    //     }
    //   }
    // }
    // if (!created) {
    //   print("new room created");
    //   ChatRoom newchatroom =
    //       ChatRoom(chatId: uuid.v1(), lastMsg: "", participants: {
    //     user: true,
    //     targetModel.uid.toString(): true,
    //   });
    //   await FirebaseFirestore.instance
    //       .collection("chatroom")
    //       .doc(newchatroom.chatId)
    //       .set(newchatroom.toMap());
    //   log("done.....");
    //   chatRoom = newchatroom;
    // }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search User"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: "please enter uesrname's of your friend",
                ),
              ),
            ),
            MaterialButton(
              color: Colors.blue,
              onPressed: () {
                FocusScope.of(context).unfocus();
                setState(() {});
              },
              minWidth: 100,
              child: const Text("search"),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("user")
                  .where("username", isEqualTo: controller.text)
                  .where("username", isNotEqualTo: username)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    final snapshotData = snapshot.data;
                    if (snapshotData!.docs.isNotEmpty) {
                      final data =
                          snapshotData.docs[0].data() as Map<String, dynamic>;
                      UserModel searchUser = UserModel.fromMap(data);

                      if (data.isNotEmpty) {
                        return GestureDetector(
                            onTap: () async {
                              ChatRoom? chatRoom =
                                  await getchatRoom(searchUser);
                              if (chatRoom != null) {
                                Navigator.of(context).pop();
                                Get.to(
                                  () => ChatScreen(
                                    targetUser: searchUser,
                                    user: userModel!,
                                    chatRoom: chatRoom,
                                  ),
                                );
                              }
                            },
                            child: ListTile(
                              title: Text(searchUser.username.toString()),
                              leading: CircleAvatar(
                                backgroundImage: searchUser.profile!.isNotEmpty
                                    ? NetworkImage(searchUser.profile!)
                                    : null,
                              ),
                              subtitle: Text(searchUser.email!),
                            ));
                      } else {
                        return Text("User not found");
                      }
                    } else {
                      return Text("user not found");
                    }
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return Text("User not found");
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
