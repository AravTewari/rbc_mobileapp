import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rbc_mobileapp/backend/models/CustomUser.dart';
import 'package:rbc_mobileapp/themes/colors.dart';
import 'package:rbc_mobileapp/widgets/billItem.dart';
import 'package:http/http.dart' as http;

class OverviewPage extends StatefulWidget {
  OverviewPage({
    Key key,
    this.user,
    this.setAnalyticsScreen,
  }) : super(key: key);

  final CustomUser user;
  final Function(String) setAnalyticsScreen;

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  int _balance = 0;
  String _account = "chequing";

  @override
  void initState() {
    super.initState();
    widget.setAnalyticsScreen("OverviewPage");

    http
        .get(
            "https://singular-arcana-304003.uc.r.appspot.com/api/plaid/balance")
        .then((res) {
      dynamic body = jsonDecode(res.body)[0];
      setState(() {
        _balance = body["available"];
        _account = body["subtype"];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
                "${widget.user.group != null ? widget.user.group.name : "Welcome"}",
                style: Theme.of(context).textTheme.headline1)),
        Expanded(
            child: ListView(
          children: [
            Card(
              margin: EdgeInsets.only(bottom: 16),
              color: ThemeColors.offWhite,
              child: Container(
                height: 75,
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Balance",
                      softWrap: true,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Column(children: [
                      Text(
                        "\$" + _balance.toString(),
                        softWrap: true,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Text(_account)
                    ])
                  ],
                ),
              ),
            ),
            BillItem(name: "Water", user: widget.user),
            BillItem(name: "Electricity", user: widget.user),
            BillItem(name: "Internet", user: widget.user),
            BillItem(name: "Heating & Cooling", user: widget.user),
            BillItem(name: "Netflix", user: widget.user)
          ],
        ))
      ],
    );
  }
}
