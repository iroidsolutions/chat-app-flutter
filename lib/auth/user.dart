import 'package:chat_app/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  static Future<UserModel?> getUserId(String uid) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("user").doc(uid).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    UserModel userModel = UserModel.fromMap(data);

    return userModel;
  }
}
