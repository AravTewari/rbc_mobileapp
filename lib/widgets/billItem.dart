import 'package:flutter/material.dart';
import 'package:rbc_mobileapp/backend/models/CustomUser.dart';
import 'package:rbc_mobileapp/themes/colors.dart';

class BillItem extends StatelessWidget {
  final String name;
  final CustomUser user;

  BillItem({Key key, this.name, this.user}) : super(key: key);

  List<Widget> avatars = [];

  @override
  Widget build(BuildContext context) {
    if (user.group != null) {
      user.group.members.forEach((member) {
        avatars.add(new Container(
            padding: EdgeInsets.all(4),
            child: CircleAvatar(
              backgroundImage: NetworkImage(member.photoUrl),
            )));
      });
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      color: ThemeColors.offWhite,
      child: Container(
          height: 150,
          padding: EdgeInsets.all(8),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      softWrap: true,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Container(
                        height: 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor),
                            onPressed: () {},
                            child: Text("Pay",
                                style: Theme.of(context).textTheme.headline2)))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: avatars,
                )
              ])),
    );
  }
}
