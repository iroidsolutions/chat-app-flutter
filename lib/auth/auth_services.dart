import 'package:chat_app/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class AuthService extends GetxController {
  static AuthService authService = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;

  late Rx<User?> user;

  @override
  void onReady() {
    super.onReady();
    user = Rx<User?>(auth.currentUser);
    print(user);
    user.bindStream(auth.userChanges());
    ever(user, intialScreen);
  }

  intialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginScreen());
    } else {
      Get.offAll(() => HomeScreen());
    }
  }

  void registration(String email, String pass, String username) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: pass)
          .then((currentUser) async {
        UserModel userModel = UserModel(
          email: email,
          profile: "",
          uid: currentUser.user!.uid,
          username: username,
        );
        await FirebaseFirestore.instance
            .collection("user")
            .doc(currentUser.user!.uid)
            .set(userModel.toMap());
      });
    } catch (e) {
      Get.snackbar(
        "Error",
        "Error",
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
  }

  void login(String email, String pass) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: pass);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
  }

  void logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      // TODO
      Get.snackbar(
        "Error",
        e.toString(),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
  }
}
