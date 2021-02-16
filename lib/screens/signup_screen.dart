import 'dart:math';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/constant_localizations.dart';
import 'tabs_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;

  UserCredential _userCredential;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController repassController = TextEditingController();
  Future<void> _showErrorDialog(String message) {
    return Fluttertoast.showToast(
        msg: getTranslated(context, message),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1);
  }

  Future<void> _onSubmit() async {
    String username = nameController.value.text.toString().trim();
    String email = emailController.value.text.toString().trim();
    String password = passController.value.text.toString().trim();
    String repassword = repassController.value.text.toString().trim();

    if (!(username.length > 1)) {
      _showErrorDialog("plsentuser");
    } else if (EmailValidator.validate(email) == false) {
      _showErrorDialog("plsentmail");
    } else if (!(password.length > 5)) {
      _showErrorDialog("plsentpass");
    } else if (!(repassController.value.text.toString().trim().length > 5)) {
      _showErrorDialog("plsentrpass");
    } else if (repassword != password) {
      _showErrorDialog("dontmatchpass");
    } else {
      try {
        _userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('id', _userCredential.user.uid);
        await prefs.setString('token', _userCredential.user.refreshToken);
        String languageCode = prefs.getString(LANGUAGE_CODE);
        Random random = Random();
        int ranNum = random.nextInt(18);
        String ranNumStr = ranNum.toString();
        print(languageCode);
        final ref = await FirebaseStorage.instance
            .ref()
            .child('default_images')
            .child('def-$ranNumStr.jpg')
            .getDownloadURL();

        FirebaseDatabase.instance
            .reference()
            .child('users')
            .child(_userCredential.user.uid)
            .set({
          'username': username,
          'email': email,
          'lang': languageCode,
          'level': 1,
          'profilePhoto': ref,
          'createdAt': ServerValue.timestamp,
          'address': '',
          'phone': '',
          'emailVerify': false,
          'phoneVerify': false,
          'loc_lat': '',
          'loc_lng': '',
          'country': '',
          'city': ''
        });
        pushNewScreen(
          context,
          screen: TabsScreen(
            menuScreenContext: context,
          ),
        );
      } catch (error) {
        _showErrorDialog(error);
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    nameController.dispose();
    passController.dispose();
    emailController.dispose();
    repassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: true,
          body: ListView(
            shrinkWrap: true,
            reverse: false,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(SignUpScreen.routeName);
                                    })),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 0.0, bottom: 0.0, top: 0.0),
                              child: Text(getTranslated(context, "SIGNUP"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                  textAlign: TextAlign.left),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/images/jump.gif",
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Center(
                      child: Center(
                    child: Stack(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 30.0, right: 30.0),
                            child: Form(
                              key: _formKey,
                              autovalidate: false,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: TextFormField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                          labelText: getTranslated(
                                              context, "username"),
                                          filled: false,
                                          prefixIcon: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 7.0),
                                              child: Image.asset(
                                                "assets/images/user_icon.png",
                                                height: 25.0,
                                                width: 25.0,
                                                fit: BoxFit.scaleDown,
                                              ))),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0, top: 5.0),
                                      child: TextFormField(
                                        obscureText: false,
                                        controller: emailController,
                                        decoration: InputDecoration(
                                            labelText:
                                                getTranslated(context, "email"),
                                            enabled: true,
                                            filled: false,
                                            prefixIcon: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 7.0),
                                                child: Image.asset(
                                                  "assets/images/email_icon.png",
                                                  height: 25.0,
                                                  width: 25.0,
                                                  fit: BoxFit.scaleDown,
                                                ))),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0, top: 5.0),
                                      child: TextFormField(
                                        obscureText: true,
                                        controller: passController,
                                        decoration: InputDecoration(
                                            labelText: getTranslated(
                                                context, "password"),
                                            enabled: true,
                                            filled: false,
                                            prefixIcon: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 7.0),
                                                child: Image.asset(
                                                  "assets/images/password_icon.png",
                                                  height: 25.0,
                                                  width: 25.0,
                                                  fit: BoxFit.scaleDown,
                                                ))),
                                        keyboardType: TextInputType.text,
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0, top: 5.0),
                                      child: TextFormField(
                                        obscureText: true,
                                        controller: repassController,
                                        decoration: new InputDecoration(
                                            labelText:
                                                getTranslated(context, "rpass"),
                                            enabled: true,
                                            filled: false,
                                            prefixIcon: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 7.0),
                                                child: Image.asset(
                                                  "assets/images/password_icon.png",
                                                  height: 25.0,
                                                  width: 25.0,
                                                  fit: BoxFit.scaleDown,
                                                ))),
                                        keyboardType: TextInputType.text,
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 0.0, top: 45.0, bottom: 20.0),
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      onPressed: _onSubmit,
                                      child: new Text(
                                        getTranslated(context, "SignUp"),
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      color: Color(0xFF54C5F8),
                                      textColor: Colors.white,
                                      elevation: 5.0,
                                      padding: EdgeInsets.only(
                                          left: 80.0,
                                          right: 80.0,
                                          top: 15.0,
                                          bottom: 15.0),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ))
                ],
              )
            ],
          )),
    );
  }
}
