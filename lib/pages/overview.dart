import 'package:flutter/material.dart';
import 'package:rbc_mobileapp/backend/models/CustomUser.dart';
import 'package:rbc_mobileapp/widgets/expenseListItem.dart';

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
  @override
  void initState() {
    super.initState();
    widget.setAnalyticsScreen("OverviewPage");
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
        Text("${widget.user.group.name}",
            style: Theme.of(context).textTheme.headline1),
      ],
    );
  }
}
