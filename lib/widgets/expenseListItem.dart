import 'package:flutter/material.dart';

class ExpenseListItem extends StatelessWidget {
  final String name;
  final Function(String) onRemovePressed;

  const ExpenseListItem({Key key, this.name, this.onRemovePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(name, style: Theme.of(context).textTheme.headline5),
      IconButton(
          padding: EdgeInsets.all(16),
          icon: Icon(Icons.close),
          onPressed: () {
            this.onRemovePressed(this.name);
          })
    ]);
  }
}
