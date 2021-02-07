import 'package:rbc_mobileapp/backend/models/CustomUser.dart';

class CustomGroup {
  String id;
  String name;
  List<CustomUser> members;

  CustomGroup(String id, String name, List<CustomUser> members) {
    this.id = id;
    this.name = name;
    this.members = members;
  }

  @override
  String toString() {
    return "ID: ${this.id}, Name: ${this.name}, Members: ${this.members}";
  }
}
