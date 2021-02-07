import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:rbc_mobileapp/backend/models/CustomGroup.dart';
import 'package:rbc_mobileapp/backend/models/CustomUser.dart';
import 'package:rbc_mobileapp/pages/expenseBoard.dart';
import 'package:rbc_mobileapp/pages/groups.dart';
import 'package:http/http.dart' as http;
import 'package:rbc_mobileapp/pages/overview.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {Key key,
      this.user,
      this.logoutCallback,
      this.setAnalyticsScreen,
      this.plaidLink,
      this.isNewuser})
      : super(key: key);

  final CustomUser user;
  final bool isNewuser;
  final PlaidLink plaidLink;
  final VoidCallback logoutCallback;
  final Function(String screenName) setAnalyticsScreen;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int onBoardProgress = 0;
  Widget page = Container();

  @override
  void initState() {
    super.initState();
    widget.setAnalyticsScreen("HomePage");

    if (widget.user.group == null) {
      setState(() {
        page = GroupsPage(
            user: widget.user,
            finishCallback: groupFinished,
            setAnalyticsScreen: widget.setAnalyticsScreen);
      });
    } else {
      setState(() {
        page = OverviewPage(
            user: widget.user, setAnalyticsScreen: widget.setAnalyticsScreen);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> groupFinished(String name, List<String> emails) async {
    setState(() {
      page = ExpensesPage(
          user: widget.user,
          plaidLink: widget.plaidLink,
          finishedCallback: linkFinished,
          setAnalyticsScreen: widget.setAnalyticsScreen);
    });

    var groupUrl =
        "https://singular-arcana-304003.uc.r.appspot.com/api/groups/";
    http.Response groupRes = await http.post(groupUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"name": name, "creator_id": widget.user.uid, "disabled": false}));

    for (var email in emails) {
      var memberUrl =
          "https://singular-arcana-304003.uc.r.appspot.com/api/groupmembers/";
      dynamic groupBody = jsonDecode(groupRes.body);
      await http.post(memberUrl,
          headers: {"Content-Type": "application/json"},
          body:
              jsonEncode({"group_id": groupBody["group_id"], "email": email}));
    }

    var findGroupUrl =
        "https://singular-arcana-304003.uc.r.appspot.com/api/groups/ownergroup/${widget.user.uid}";
    http.Response res = await http.get(findGroupUrl);

    dynamic body = jsonDecode(res.body);
    List<dynamic> memRaw = body["GroupMembers"];
    List<CustomUser> memParsed = [];
    memRaw.forEach((m) {
      memParsed.add(new CustomUser(m["Client"]["client_id"], null,
          m["Client"]["profileUrl"], m["Client"]["email"], null));
    });

    CustomGroup g = new CustomGroup(body["group_id"], body["name"], memParsed);
    widget.user.setGroup(g);
  }

  void linkFinished() {
    setState(() {
      page = OverviewPage(
          user: widget.user, setAnalyticsScreen: widget.setAnalyticsScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(right: 10),
                  child: InkWell(
                      onLongPress: widget.logoutCallback,
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.user.user.photoURL),
                      ))),
              Text(
                widget.user.user.displayName,
                style: Theme.of(context).textTheme.headline5,
              )
            ],
          ),
        ),
        Expanded(child: this.page),
      ],
    );
  }
}
