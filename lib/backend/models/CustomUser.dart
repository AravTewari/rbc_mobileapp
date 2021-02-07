import 'package:firebase_auth/firebase_auth.dart';
import 'package:rbc_mobileapp/backend/models/CustomGroup.dart';

class CustomUser {
  String uid;
  String photoUrl;
  String email;
  CustomGroup group;
  User user;

  CustomUser(
      String uid, CustomGroup group, String photoUrl, String email, User user) {
    this.uid = uid;
    this.group = group;
    this.photoUrl = photoUrl;
    this.user = user;
  }

  void setGroup(CustomGroup group) {
    this.group = group;
  }

  String toString() {
    return 'UID: ${this.uid}, Group: ${this.group.toString()}, Photo: ${this.photoUrl}';
  }
}
