import 'package:firebase_auth/firebase_auth.dart';

class CustomUser {
  String uid;
  User user;

  CustomUser(String uid, User user) {
    this.uid = uid;
    this.user = user;
  }

  String toString() {
    return 'UID: ${this.uid}';
  }
}
