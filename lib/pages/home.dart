import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rbc_mobileapp/widgets/checkboxOption.dart';
import 'package:rbc_mobileapp/widgets/expenseListItem.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.user, this.logoutCallback, this.setAnalyticsScreen})
      : super(key: key);

  final User user;
  final VoidCallback logoutCallback;
  final Function(String screenName) setAnalyticsScreen;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ExpenseListItem> customExpenses = [];
  TextEditingController _expenseTextController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.setAnalyticsScreen("HomePage");
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addExpense() {
    if (_expenseTextController.text == "" ||
        customExpenses
            .where((item) =>
                item.name.toLowerCase() ==
                _expenseTextController.text.toLowerCase())
            .isNotEmpty) return;

    List<ExpenseListItem> tmpExp = customExpenses;
    tmpExp.add(new ExpenseListItem(
        name: _expenseTextController.text, onRemovePressed: removeExpense));
    setState(() {
      customExpenses = tmpExp;
    });

    _expenseTextController.clear();
  }

  void removeExpense(String name) {
    List<ExpenseListItem> tmpExp = customExpenses;
    tmpExp.removeWhere((item) => item.name == name);
    setState(() {
      customExpenses = tmpExp;
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
                      onTap: widget.logoutCallback,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(widget.user.photoURL),
                      ))),
              Text(
                widget.user.displayName,
                style: Theme.of(context).textTheme.headline5,
              )
            ],
          ),
        ),
        Text("Shared Bills", style: Theme.of(context).textTheme.headline1),
        CheckboxOption(name: "Water"),
        CheckboxOption(name: "Electricity"),
        CheckboxOption(name: "Internet"),
        CheckboxOption(name: "HVAC"),
        Divider(thickness: 1.5),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
              width: MediaQuery.of(context).size.width - 110,
              padding: EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 4),
              margin: EdgeInsets.only(bottom: 16, top: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).canvasColor,
              ),
              child: TextField(
                controller: _expenseTextController,
                style: Theme.of(context).textTheme.headline5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Custom Expense",
                  hintStyle: Theme.of(context).textTheme.headline5,
                  icon: Icon(Icons.create),
                ),
              )),
          Container(
              margin: EdgeInsets.only(bottom: 16, top: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).primaryColor,
              ),
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: addExpense,
                padding: EdgeInsets.all(16),
                color: Theme.of(context).backgroundColor,
              ))
        ]),
        Expanded(
            child: ListView.builder(
                itemCount: this.customExpenses.length,
                itemBuilder: (context, index) => this.customExpenses[index])),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            margin: EdgeInsets.only(top: 16),
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    textStyle: Theme.of(context).textTheme.headline6),
                onPressed: () {},
                icon: Icon(Icons.arrow_forward),
                label: Text("Continue")))
      ],
    );
  }
}
