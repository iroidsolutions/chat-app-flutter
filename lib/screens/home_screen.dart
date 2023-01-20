import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/auth/auth_services.dart';
import 'package:chat_app/auth/user.dart';
import 'package:chat_app/models/chat_room.dart';
import 'package:chat_app/models/usermodel.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/search_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentUserUid;
  UserModel? userModel;
  var load = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUserUid = AuthService.authService.auth.currentUser!.uid;
    getdata();
  }

  Future getdata() async {
    setState(() {
      load = true;
    });
    CollectionReference snap = FirebaseFirestore.instance.collection("user");

    var data = snap.doc(currentUserUid).get().then((value) {
      Map<String, dynamic> snapshot = value.data() as Map<String, dynamic>;
      userModel = UserModel.fromMap(snapshot);
    });
    setState(() {
      load = false;
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
      body: load
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatroom")
                  .where("participants.$currentUserUid", isEqualTo: true)
                  .orderBy("createdon")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot querySnapshot =
                        snapshot.data as QuerySnapshot;
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        ChatRoom chatRoom = ChatRoom.fromMap(
                            querySnapshot.docs[index].data()
                                as Map<String, dynamic>);

                        Map<String, dynamic>? participants =
                            chatRoom.participants;

                        List<String> participantsKey =
                            participants!.keys.toList();
                        participantsKey.remove(currentUserUid);
                        print(participantsKey);
                        return FutureBuilder(
                          future: User.getUserId(participantsKey[0]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.data != null) {
                                UserModel targetUser =
                                    snapshot.data as UserModel;

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
                                    leading: CachedNetworkImage(
                                      width: 50,
                                      imageUrl: targetUser.profile!,
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    title: Text(targetUser.username!),
                                    subtitle: chatRoom.lastMsg!.isNotEmpty
                                        ? Text(chatRoom.lastMsg!)
                                        : const Text("Say, hii to your friend"),
                                    trailing: Text(DateFormat('MM/dd/yyyy')
                                        .format(chatRoom.createdon!)),
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
                      child: Text("No Data found"),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
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
