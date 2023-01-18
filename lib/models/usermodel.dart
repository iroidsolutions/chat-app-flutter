class UserModel {
  String? uid;
  String? email;
  String? username;
  String? profile;

  UserModel(
      {required this.uid,
      required this.email,
      required this.username,
      required this.profile});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    email = map['email'];
    username = map['username'];
    profile = map['profile'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'profile': profile,
    };
  }
}
