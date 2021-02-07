import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
    var url = "https://singular-arcana-304003.uc.r.appspot.com/api/clients/";
    http.Response res = await http.post(url,
        body: jsonEncode({"uid": user.uid, "email": user.email}));

    dynamic body = jsonDecode(res.body);

    CustomUser cu = new CustomUser(body["uid"], user);
    return cu;
  }

  static Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
  }
}
