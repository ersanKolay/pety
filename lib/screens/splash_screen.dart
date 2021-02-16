import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pety/models/profile.dart';
import 'package:pety/screens/tabs_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  Connectivity connectivity;
  AnimationController animationController;
  Animation<double> animation;
  User _user;
  startTime() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, _checkUser);
  }

  Future<void> _checkUser() async {
    _user = FirebaseAuth.instance.currentUser;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_user == null) {
      print("User id: null");
      _prefs.setString('id', null);
      pushNewScreen(
        context,
        screen: TabsScreen(
          menuScreenContext: context,
          userID: null,
        ),
      );
    } else {
      print("User id: " + _user.uid);
      _prefs.setString('id', _user.uid);
      
      pushNewScreen(
        context,
        screen: TabsScreen(
          menuScreenContext: context,
          userID: _user.uid,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  /*  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_user.uid == null) {
      await prefs.setString('id', null);
      pushNewScreen(
        context,
        screen: TabsScreen(
          menuScreenContext: context,
        ),
      );
    } else {
    
      pushNewScreen(
        context,
        screen: TabsScreen(
          menuScreenContext: context,
        ),
      );
    } */
  /* if (prefs.getString('id') == null) {
        //Navigator.pushReplacementNamed(context, LogInScreen.routeName);
        pushNewScreen(
          context,
          screen: TabsScreen(
            menuScreenContext: context,
          ),
        );
      } else {
        await prefs.setString('id', "Default");
        pushNewScreen(
          context,
          screen: TabsScreen(
            menuScreenContext: context,
          ),
        );
      }
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: new Image.asset(
                    'assets/images/powered_by.png',
                    height: 25.0,
                    fit: BoxFit.scaleDown,
                  ))
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/images/logo.png',
                width: animation.value * 250,
                height: animation.value * 250,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
