import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:http/http.dart' as http;

class Plaid {
  static PlaidLink _plaidLinkToken;

  static Future<PlaidLink> linkPlaidAccount(User user) async {
    var url =
        "https://singular-arcana-304003.uc.r.appspot.com/api/plaid/link-token?id=${user.uid}";
    http.Response res = await http.get(url);
    dynamic body = jsonDecode(res.body);

    LinkConfiguration linkTokenConfiguration = LinkConfiguration(
      token: body["link_token"],
    );

    _plaidLinkToken = PlaidLink(
      configuration: linkTokenConfiguration,
      onSuccess: _onSuccessCallback,
      onEvent: _onEventCallback,
      onExit: _onExitCallback,
    );

    return _plaidLinkToken;
  }

  static void _onSuccessCallback(
      String publicToken, LinkSuccessMetadata metadata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url =
        "https://singular-arcana-304003.uc.r.appspot.com/api/plaid/access-token";
    http.Response res =
        await http.post(url, body: jsonEncode({"publicToken": publicToken}));
    dynamic body = jsonDecode(res.body);
    await prefs.setString("access-token", body["access-token"]);
    await prefs.setString("item_id", body["item_id"]);
  }

  static void _onEventCallback(String event, LinkEventMetadata metadata) {}

  static void _onExitCallback(LinkError error, LinkExitMetadata metadata) {
    if (error != null) {
      print("onExit error: ${error.description()}");
    }
  }
}
