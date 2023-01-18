import 'dart:io';

import 'package:chat_app/auth/auth_services.dart';
import 'package:chat_app/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? image;
  var networkImage;
  var uid;
  UserModel? userModel;
  var username;

  void showOption() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("upload Image"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  pickImage(ImageSource.gallery);
                },
                child: const ListTile(
                  leading: Icon(Icons.upload),
                  title: Text("Gallaray"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  pickImage(ImageSource.camera);
                },
                child: const ListTile(
                  leading: Icon(Icons.camera),
                  title: Text("Camera"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void pickImage(ImageSource imageSource) async {
    XFile? file =
        await ImagePicker().pickImage(source: imageSource, imageQuality: 50);
    image = File(file!.path);
    setState(() {});
  }

  void submitProfile() async {
    if (image == null) {
      Get.snackbar("Image", "Please select Image first");
    } else {
      uploadProfile();
    }
  }

  void uploadProfile() async {
    TaskSnapshot profile = await FirebaseStorage.instance
        .ref("Profile")
        .child(uid)
        .putFile(image!);
    var geturl = await profile.ref.getDownloadURL();

    try {
      await FirebaseFirestore.instance.collection("user").doc(uid).update({
        'profile': geturl,
      }).then((value) => Navigator.of(context).pop());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = AuthService.authService.auth.currentUser!.uid;
    getProfile();
  }

  void getProfile() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("user").doc(uid).get();
    Map<String, dynamic> profile = snapshot.data() as Map<String, dynamic>;

    userModel = UserModel.fromMap(profile);
    var picture = userModel!.profile;
    username = userModel!.username;
    setState(() {
      networkImage = picture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username ?? ""),
      ),
      body: ListView(
        children: [
          MaterialButton(
            padding: const EdgeInsets.all(10),
            onPressed: () {
              showOption();
            },
            child: image != null
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: image != null ? FileImage(image!) : null,
                    child: image == null ? const Icon(Icons.person) : null,
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundImage: networkImage != null
                        ? NetworkImage(networkImage)
                        : const NetworkImage(
                            'https://i.stack.imgur.com/l60Hf.png'),
                    child:
                        networkImage == null ? const Icon(Icons.person) : null,
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: CupertinoButton(
              color: Colors.blue,
              minSize: 50,
              padding: const EdgeInsets.all(10),
              onPressed: () {
                submitProfile();
                // Navigator.of(context).pop();
              },
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }
}
