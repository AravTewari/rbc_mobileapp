import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:rbc_mobileapp/backend/models/CustomUser.dart';
import 'package:rbc_mobileapp/pages/expenseBoard.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {Key key,
      this.user,
      this.logoutCallback,
      this.setAnalyticsScreen,
      this.plaidLink})
      : super(key: key);

  final CustomUser user;
  final PlaidLink plaidLink;
  final VoidCallback logoutCallback;
  final Function(String screenName) setAnalyticsScreen;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    widget.setAnalyticsScreen("HomePage");
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
          margin: EdgeInsets.only(bottom: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(right: 10),
                  child: InkWell(
                      onTap: widget.logoutCallback,
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
        Expanded(
            child: ExpensesPage(
                user: widget.user,
                setAnalyticsScreen: widget.setAnalyticsScreen,
                plaidLink: widget.plaidLink,
                logoutCallback: widget.logoutCallback)),
      ],
    );
  }
}
