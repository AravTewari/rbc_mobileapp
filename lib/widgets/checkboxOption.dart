import 'package:flutter/material.dart';

class CheckboxOption extends StatefulWidget {
  CheckboxOption({Key key, this.name, this.checked = false}) : super(key: key);

  final String name;
  final bool checked;

  @override
  _CheckboxOptionState createState() => _CheckboxOptionState();
}

class _CheckboxOptionState extends State<CheckboxOption> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.checked;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Checkbox(
          fillColor: MaterialStateProperty.resolveWith(
              (state) => Theme.of(context).primaryColor),
          checkColor: Theme.of(context).backgroundColor,
          value: this.isChecked,
          onChanged: (bool value) {
            setState(() {
              this.isChecked = value;
            });
          }),
      Text(widget.name, style: Theme.of(context).textTheme.headline5)
    ]);
  }
}
