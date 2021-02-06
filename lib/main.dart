import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:rbc_mobileapp/themes/colors.dart';
import 'package:rbc_mobileapp/backend/auth/auth.dart';

import 'package:rbc_mobileapp/pages/login.dart';
import 'package:rbc_mobileapp/pages/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(App());
  });
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class App extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  Widget buildWaiting() {
    return MaterialApp(
        title: 'Loading...',
        home: Scaffold(
          backgroundColor: ThemeColors.white,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return buildWaiting();

          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'RBC Challenge',
              themeMode: ThemeMode.light,
              theme: ThemeData(
                  primaryColor: ThemeColors.black,
                  backgroundColor: ThemeColors.white,
                  fontFamily: 'WorkSans',
                  canvasColor: ThemeColors.lightGrey,
                  textTheme: TextTheme(
                      headline1: TextStyle(
                          color: ThemeColors.black,
                          fontSize: 36,
                          fontWeight: FontWeight.bold),
                      headline5:
                          TextStyle(color: ThemeColors.black, fontSize: 16),
                      headline6:
                          TextStyle(color: ThemeColors.white, fontSize: 18))),
              // darkTheme: ThemeData(
              //     primaryColor: ThemeColors.white,
              //     backgroundColor: ThemeColors.black,
              //     fontFamily: 'WorkSans',
              //     canvasColor: ThemeColors.lightGrey,
              //     textTheme: TextTheme(
              //         headline1: TextStyle(
              //             color: ThemeColors.white,
              //             fontSize: 36,
              //             fontWeight: FontWeight.bold),
              //         headline5:
              //             TextStyle(color: ThemeColors.white, fontSize: 16),
              //         headline6:
              //             TextStyle(color: ThemeColors.black, fontSize: 18))),
              home: Root(analytics: analytics),
              navigatorObservers: [
                FirebaseAnalyticsObserver(analytics: analytics),
              ],
            );
          }

          return buildWaiting();
        });
  }
}

class Root extends StatefulWidget {
  Root({Key key, this.analytics}) : super(key: key);

  final FirebaseAnalytics analytics;

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  FirebaseAuth auth = FirebaseAuth.instance;

  AuthStatus status = AuthStatus.NOT_DETERMINED;
  Widget page;

  User user;

  @override
  void initState() {
    super.initState();

    auth.authStateChanges().listen((User user) {
      if (user == null) {
        setState(() {
          status = AuthStatus.NOT_LOGGED_IN;
        });
      } else {
        setState(() {
          status = AuthStatus.LOGGED_IN;
          this.user = user;
        });
      }
    });

    widget.analytics.logAppOpen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loginCallback() {
    Auth.signInWithGoogle().then((user) => {
          setState(() {
            this.user = user;
            status = AuthStatus.LOGGED_IN;
          })
        });
  }

  void logoutCallback() {
    Auth.signOutGoogle().then((v) => {
          setState(() {
            status = AuthStatus.NOT_LOGGED_IN;
          })
        });
  }

  Future<void> setAnalyticsScreen(String screenName) async {
    await widget.analytics.setCurrentScreen(screenName: screenName);
  }

  Future<void> setAnalyticsUser(User user) async {
    await widget.analytics.setUserId(user.uid);
  }

  Widget buildWaiting() {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case AuthStatus.NOT_DETERMINED:
        setState(() {
          page = buildWaiting();
        });
        break;
      case AuthStatus.NOT_LOGGED_IN:
        setState(() {
          page = LoginPage(
            setAnalyticsScreen: setAnalyticsScreen,
            loginCallback: loginCallback,
          );
        });
        break;
      case AuthStatus.LOGGED_IN:
        setAnalyticsUser(this.user);
        setState(() {
          page = HomePage(
            setAnalyticsScreen: setAnalyticsScreen,
            user: this.user,
            logoutCallback: logoutCallback,
          );
        });
        break;
      default:
        setState(() {
          page = LoginPage(
            setAnalyticsScreen: setAnalyticsScreen,
            loginCallback: loginCallback,
          );
        });
        break;
    }
    return new Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
            child: Container(padding: EdgeInsets.all(20), child: page)));
  }
}
