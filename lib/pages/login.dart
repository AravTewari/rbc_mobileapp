import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.loginCallback, this.setAnalyticsScreen})
      : super(key: key);

  final VoidCallback loginCallback;
  final Function(String screenName) setAnalyticsScreen;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    widget.setAnalyticsScreen("LoginPage");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Login to\nRentTogether.online",
            style: Theme.of(context).textTheme.headline1),
        Image.network("https://i.imgur.com/c7yjrRb.png"),
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    textStyle: Theme.of(context).textTheme.headline6),
                onPressed: widget.loginCallback,
                child: Text("Continue with Google")))
      ],
    );
  }
}
