import 'package:flutter/material.dart';
import 'package:rbc_mobileapp/backend/models/CustomUser.dart';
import 'package:rbc_mobileapp/widgets/expenseListItem.dart';

class GroupsPage extends StatefulWidget {
  GroupsPage({
    Key key,
    this.user,
    this.setAnalyticsScreen,
    this.finishCallback,
  }) : super(key: key);

  final CustomUser user;
  final Function(String, List<String>) finishCallback;
  final Function(String) setAnalyticsScreen;

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  List<ExpenseListItem> invitees = [];
  TextEditingController _groupNameController = new TextEditingController();
  TextEditingController _groupInvitesController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.setAnalyticsScreen("GroupsPage");
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addInvite() {
    if (_groupInvitesController.text == "" ||
        invitees
            .where((item) =>
                item.name.toLowerCase() ==
                _groupInvitesController.text.toLowerCase())
            .isNotEmpty) return;

    List<ExpenseListItem> tmpExp = invitees;
    tmpExp.add(new ExpenseListItem(
        name: _groupInvitesController.text, onRemovePressed: removeInvite));
    setState(() {
      invitees = tmpExp;
    });

    _groupInvitesController.clear();
  }

  void removeInvite(String name) {
    List<ExpenseListItem> tmpExp = invitees;
    tmpExp.removeWhere((item) => item.name == name);
    setState(() {
      invitees = tmpExp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Create Group", style: Theme.of(context).textTheme.headline1),
        Container(
            padding: EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 4),
            margin: EdgeInsets.only(bottom: 16, top: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).canvasColor,
            ),
            child: TextField(
              controller: _groupNameController,
              style: Theme.of(context).textTheme.headline5,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Group Name",
                hintStyle: Theme.of(context).textTheme.headline5,
                icon: Icon(Icons.create),
              ),
            )),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Container(
                  padding:
                      EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 4),
                  margin: EdgeInsets.only(bottom: 16, top: 8, right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).canvasColor,
                  ),
                  child: TextField(
                    controller: _groupInvitesController,
                    keyboardType: TextInputType.emailAddress,
                    style: Theme.of(context).textTheme.headline5,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Invite Users",
                      hintStyle: Theme.of(context).textTheme.headline5,
                      icon: Icon(Icons.mail),
                    ),
                  ))),
          Container(
              margin: EdgeInsets.only(bottom: 16, top: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).primaryColor,
              ),
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: addInvite,
                padding: EdgeInsets.all(16),
                color: Theme.of(context).backgroundColor,
              ))
        ]),
        Expanded(
            child: ListView.builder(
                itemCount: this.invitees.length,
                itemBuilder: (context, index) => this.invitees[index])),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            margin: EdgeInsets.only(top: 16),
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    textStyle: Theme.of(context).textTheme.headline6),
                onPressed: () {
                  List<String> strInvites = [];
                  invitees.forEach((inviteWidget) {
                    strInvites.add(inviteWidget.name);
                  });
                  widget.finishCallback(_groupNameController.text, strInvites);
                },
                icon: Icon(Icons.arrow_forward),
                label: Text("Create Group")))
      ],
    );
  }
}
