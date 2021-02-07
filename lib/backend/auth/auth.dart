import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rbc_mobileapp/backend/models/CustomGroup.dart';
import 'package:rbc_mobileapp/backend/models/CustomUser.dart';
import 'package:http/http.dart' as http;

class Auth {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  static Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      return authResult;
    }

    return null;
  }

  static Future<CustomUser> getUser(User user) async {
    FirebaseMessaging messaging = FirebaseMessaging();
    var url = "https://singular-arcana-304003.uc.r.appspot.com/api/clients/";
    http.Response res = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "uid": user.uid,
          "email": user.email,
          "profileURL": user.photoURL,
          "registrationToken": await messaging.getToken()
        }));

    dynamic body = jsonDecode(res.body);
    // print(body);

    CustomUser cu = new CustomUser(
        body["client_id"], null, user.photoURL, user.email, user);

    var findGroupUrl =
        "https://singular-arcana-304003.uc.r.appspot.com/api/groups/clientgroups/${user.uid}";
    http.Response rez = await http.get(findGroupUrl);
    dynamic json = jsonDecode(rez.body);
    // print(json);
    if (json["GroupMembers"] != null) {
      List<dynamic> memRaw = json["GroupMembers"];
      List<CustomUser> memParsed = [];
      memRaw.forEach((m) {
        memParsed.add(new CustomUser(m["Client"]["client_id"], null,
            m["Client"]["profileURL"], m["Client"]["email"], null));
      });

      CustomGroup g =
          new CustomGroup(json["group_id"], json["name"], memParsed);
      cu.setGroup(g);
    }

    print(cu.toString());
    return cu;
  }

  static Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
  }
}
