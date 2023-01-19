import 'package:chat_app/auth/auth_services.dart';
import 'package:chat_app/auth/user.dart';
import 'package:chat_app/models/chat_room.dart';
import 'package:chat_app/models/usermodel.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/search_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentUserUid = AuthService.authService.auth.currentUser!.uid;
  var user;
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

    var data = snap.doc(user).get().then((value) {
      Map<String, dynamic> snapshot = value.data() as Map<String, dynamic>;
      userModel = UserModel.fromMap(snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              AuthService.authService.logout();
            },
            icon: const Icon(Icons.logout)),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const ProfileScreen());
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chatroom")
            .where("participants.${currentUserUid}", isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  ChatRoom chatRoom = ChatRoom.fromMap(
                      querySnapshot.docs[index].data() as Map<String, dynamic>);

                  Map<String, dynamic>? participants = chatRoom.participants;

                  List<String> participantsKey = participants!.keys.toList();
                  participantsKey.remove(currentUserUid);
                  print(participantsKey);
                  return FutureBuilder(
                    future: User.getUserId(participantsKey[0]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data != null) {
                          UserModel targetUser = snapshot.data as UserModel;
                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                () => ChatScreen(
                                  chatRoom: chatRoom,
                                  targetUser: targetUser,
                                  user: userModel!,
                                ),
                              );
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(targetUser.profile!),
                              ),
                              title: Text(targetUser.username!),
                              subtitle: chatRoom.lastMsg!.isNotEmpty
                                  ? Text(chatRoom.lastMsg!)
                                  : const Text("Say, hii to your friend"),
                              trailing: const Icon(Icons.chevron_right),
                            ),
                          );
                        } else {
                          return const Text("No data found");
                        }
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          } else {
            return Text(".....");
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => SearchUser());
          // ChatUser.chatuser.fetchUser();
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
