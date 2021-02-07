import 'package:flutter/material.dart';
import 'package:rbc_mobileapp/backend/models/CustomUser.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

import 'package:rbc_mobileapp/widgets/expenseListItem.dart';

class ExpensesPage extends StatefulWidget {
  ExpensesPage({
    Key key,
    this.user,
    this.setAnalyticsScreen,
    this.plaidLink,
    this.finishedCallback,
  }) : super(key: key);

  final CustomUser user;
  final PlaidLink plaidLink;
  final VoidCallback finishedCallback;
  final Function(String screenName) setAnalyticsScreen;

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  List<ExpenseListItem> customExpenses = [];
  TextEditingController _expenseTextController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.setAnalyticsScreen("ExpensesPage");

    customExpenses.addAll([
      new ExpenseListItem(name: "Water", onRemovePressed: removeExpense),
      new ExpenseListItem(name: "Electricity", onRemovePressed: removeExpense),
      new ExpenseListItem(name: "Internet", onRemovePressed: removeExpense),
      new ExpenseListItem(
          name: "Heating & Cooling", onRemovePressed: removeExpense)
    ]);
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
        Text("Add Bills", style: Theme.of(context).textTheme.headline1),
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
                    controller: _expenseTextController,
                    style: Theme.of(context).textTheme.headline5,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Expense",
                      hintStyle: Theme.of(context).textTheme.headline5,
                      icon: Icon(Icons.create),
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
                onPressed: () {
                  widget.plaidLink.open();
                  widget.finishedCallback();
                },
                icon: Icon(Icons.arrow_forward),
                label: Text("Connect your Bank")))
      ],
    );
  }
}
